import 'package:app_pde/app/models/dtos/arquivo_dto.dart';
import 'package:app_pde/app/models/dtos/consulta_dto.dart';
import 'package:app_pde/app/models/materia.dart';
import 'package:app_pde/app/modules/cadastro_consulta_aluno/widgets/custom_alert_dialog.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_view_model.dart';
import 'package:app_pde/app/modules/upload_file/upload_file_store.dart';
import 'package:app_pde/app/repositories/aluno_repository.dart';
import 'package:app_pde/app/shared/controllers/base_store.dart';
import 'package:app_pde/app/shared/controllers/materias_store.dart';
import 'package:app_pde/app/shared/utlis/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'cadastro_consulta_aluno_store.g.dart';

class CadastroConsultaAlunoStore = _CadastroConsultaAlunoStore
    with _$CadastroConsultaAlunoStore;

abstract class _CadastroConsultaAlunoStore extends BaseStore with Store {
  final AlunoRepository _repository;
  final MateriasStore _materiasStore;
  final FirebaseAuth _firebaseAuth;
  final UploadFileStore _uploadFileStore;

  _CadastroConsultaAlunoStore(
    this._repository,
    this._firebaseAuth,
    this._uploadFileStore,
    this._materiasStore,
  );

  @observable
  bool isSwitched = false;

  @observable
  bool foto = false;
  @observable
  bool dwg = false;
  @observable
  bool pdf = false;
  @observable
  bool xlsx = false;
  @observable
  bool docx = false;

  @observable
  bool isOrcamento = false;

  @observable
  bool isEnabled = true;

  @action
  addIsOrcamento(bool value){
    isOrcamento = value;
    isEnabled = !value;
  }


  @observable
  String? ctrlNumeroQuestoes;

  ObservableList<Materia> get materias => _materiasStore.materias;

  final formKey = GlobalKey<FormState>();

  final ctrlDataConsulta = TextEditingController();

  final ctrlHoraInicio = TextEditingController();
  DateTime? get horaInicio =>
      DateTime.tryParse('1999-01-01 ' + ctrlHoraInicio.text);

  final ctrlHoraFim = TextEditingController();
  DateTime? get horaFim => DateTime.tryParse('1999-01-01 ' + ctrlHoraFim.text);

  final ctrlMateria = TextEditingController();

  final ctrlObservacoes = TextEditingController();

  final ctrlValorPago = TextEditingController();

  final ctrlNomeMateria = TextEditingController();

  final ctrlSoftwareResposta = TextEditingController();

  final ctrlValorEspecifico = TextEditingController();



  String? validaDataConsulta(String texto) =>
      Validators.validarDataConsulta(texto);

  String? validaHoraInicio(String texto) => Validators.validarHoraInicio(texto);

  String? validaHoraFinal(String texto) => Validators.validarHoraFinal(texto);

  String? validaObs(String texto) => Validators.validarObs(texto);

  String? validaSoftwareResposta(String texto) {
    if (isSwitched == true) {
      Validators.validaSoftwareResposta(texto);
    }
  }

  String? validaNull() {
    return null;
  }

  @action
  Future<void> saveConsulta() {
    return makeAsyncRequest(() async {
      final consultaDTO = _buildConsultaDTO();
      final consultaReference = await _repository.createConsulta(consultaDTO, isOrcamento);
      _uploadFileStore.uploadFiles.forEach(
        (file) async => await _processFileUpload(file, consultaReference),
      );
    }).then((value) => _navigateToHome());
  }

  Future<void> _processFileUpload(
    ArquivoViewModel file,
    DatabaseReference reference,
  ) async {
    var fileDTO = _buildFileDTO(file: file, consultaReference: reference);
    final downloadUrl = await _uploadFileStore.uploadSingleFile(
      fileDTO,
      devicePath: file.devicePath!,
    );
    fileDTO = fileDTO.copyWith(downloadUrl: downloadUrl);
    return reference.child('ArquivosApoio').push().set(fileDTO.toJson());
  }

  ConsultaDTO _buildConsultaDTO() {
    String horaIniciotemp = ctrlDataConsulta.text + ' ' + ctrlHoraInicio.text;
    String horasFimTemp = ctrlDataConsulta.text + ' ' + ctrlHoraFim.text;

    final tsInicio = DateTime.parse(horaIniciotemp).millisecondsSinceEpoch;
    final tsFim = DateTime.parse(horasFimTemp).millisecondsSinceEpoch;

    String? valorPago;
    if (ctrlValorPago.text.isNotEmpty && ctrlValorPago.text.length >= 4) {
      valorPago =
          ctrlValorPago.text.replaceAll('R\$', '').replaceAll(',00', '').replaceAll('.', '').trim();

    }else if(ctrlValorPago.text.isNotEmpty){
      valorPago = ctrlValorPago.text.replaceAll('R\$', '').replaceAll(',', '.').trim();

    }

    return ConsultaDTO(
      idMateria: ctrlMateria.text,
      idAluno: _firebaseAuth.currentUser!.uid,
      dataInicio: tsInicio,
      dataFim: tsInicio > tsFim ? tsFim + 24 * 60 * 60 * 1000 : tsFim,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      descricao: ctrlObservacoes.text,
      valorConsulta: valorPago != null ? double.parse(valorPago) : 0,
      numeroQuestoes: ctrlNumeroQuestoes == null ? ctrlNumeroQuestoes = '<5' : ctrlNumeroQuestoes,
      softwareResposta: ctrlSoftwareResposta.text,
      tipoArquivoResposta: getTipoArquivoResposta(),
      valEspecifico: ctrlValorEspecifico.text,
      isOrcamento: isOrcamento,
    );
  }

  ArquivoDTO _buildFileDTO({
    required ArquivoViewModel file,
    required DatabaseReference consultaReference,
  }) {
    final now = DateTime.now();
    final storageFileName = '${now.toIso8601String()}--${file.fileName}';
    final idConsulta = consultaReference.key;
    final storagePath = consultaReference
        .parent()!
        .parent()!
        .child(idConsulta)
        .child(storageFileName);
    return ArquivoDTO(
      nome: file.fileName,
      downloadUrl: '',
      storagePath: storagePath.path,
      timestamp: now.millisecondsSinceEpoch,
      fileExtension: file.fileExtension,
      size: file.size,
    );
  }

  void _navigateToHome() {
    return Modular.to.navigate('/home/minhas-consultas');
  }

  void _pushRevisaoConsultaPage() {
    Modular.to.pushNamed('/home/cadastrar-consulta/revisao');
  }

  Future<void> shouldPushNextPage(BuildContext context) async {
    if (_uploadFileStore.uploadFiles.isEmpty) {
      return showDialog(
        context: context,
        builder: (_) => const CustomAlertDialog(
          title: 'Upload de arquivos obrigatórios',
          message: 'Por favor, adicione arquivos de apoio.',
        ),
      );
    } else if (_uploadFileStore.badFiles.isNotEmpty) {
      return showDialog(
        context: context,
        builder: (_) => const CustomAlertDialog(
          title: 'Erro no upload dos arquivos',
          message:
              'Algum arquivo está com uma extensão que não é aceita. Tente um arquivo diferente.',
        ),
      );
    } else {
      if (formKey.currentState!.validate()) _pushRevisaoConsultaPage();
    }
  }

  Map<String, bool> getTipoArquivoResposta() {
    return {
      'Feito a mão com foto digitalizada': foto,
      'pdf': pdf,
      'dwg': dwg,
      'xlsx': xlsx,
      'docx': docx,

    };
  }
}
