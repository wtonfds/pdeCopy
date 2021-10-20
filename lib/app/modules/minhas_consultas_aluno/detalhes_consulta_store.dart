import 'dart:async';
import 'dart:io';

import 'package:app_pde/app/models/arquivo.dart';
import 'package:app_pde/app/models/consulta.dart';
import 'package:app_pde/app/models/orcamento.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/minhas_consultas_store.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_observable_list.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_view_model.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/consulta_view_model.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/orcamento_view_model.dart';
import 'package:app_pde/app/modules/upload_file/utils/firebase_api.dart';
import 'package:app_pde/app/repositories/firebase_repository.dart';
import 'package:app_pde/app/shared/controllers/base_store.dart';
import 'package:app_pde/app/shared/utlis/download_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'detalhes_consulta_store.g.dart';

class DetalhesConsultaStore = _DetalhesConsultaStoreBase
    with _$DetalhesConsultaStore;

abstract class _DetalhesConsultaStoreBase extends BaseStore with Store {
  final DownloadService _downloadService;
  final FirebaseRepository _repository;
  final MinhasConsultasStore _minhasConsultasStore;

  _DetalhesConsultaStoreBase(
      this._downloadService, this._repository, this._minhasConsultasStore);

  late ConsultaViewModel consulta;

  @observable
  ObservableList<PlatformFile>? uploadFiles = <PlatformFile>[].asObservable();

  UploadTask? task;
  String url = '';
  var destination;
  var situacao;
  FilePickerResult? result;

  @observable
  ArquivoObservableList files = ArquivoObservableList();

  @observable
  var statusList = false;

  @observable
  ObservableList<OrcamentoViewModel> orcamentos = <OrcamentoViewModel>[].asObservable();


  @observable
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Future<void> pushCorrecaoConsultaPage(ConsultaViewModel consulta) {
    return Modular.to.pushNamed(
        '/home/consultas/${consulta.idNumerico}/correcao',
        arguments: consulta);
  }

  _navigateToMain() => Modular.to.pushReplacementNamed('/home');

  @action
  Future<void> setAvaliarConsulta(int estrelas) async {
    makeAsyncRequest(() {
      return Future.value(
          _repository.setAvaliarConsulta(consulta.id, estrelas));
    }).then((results) async {
      if (results == null) return;
      _navigateToMain();
    });
  }

  @action
  Future<void> loadOrcamentos({required List<Orcamento>? viewOrcamentos}) async{
    viewOrcamentos!.forEach((orcamento) {
      orcamentos.add(
        OrcamentoViewModel(
            id: orcamento.id,
            idProfessor: orcamento.idProfessor,
            valorProfessor: orcamento.valorProfessor,
            valorConsulta: orcamento.valorConsulta,
            nomeFantasia: orcamento.nomeFantasia,
            alunoJaViuOrcamento: orcamento.alunoJaViuOrcamento,
            escolhido: orcamento.escolhido,
        )
      );
    });
}

  @action
  Future<void> loadDownloadedFiles({required List<Arquivo> viewFiles}) async {
    final tasks = await FlutterDownloader.loadTasks();
    viewFiles.forEach((file) {
      final fileName = '${file.timestamp.millisecondsSinceEpoch}_${file.nome}';
      final index = tasks!.indexWhere((task) => task.url == file.downloadUrl);
      if (index.isNegative) {
        files.add(ArquivoViewModel(
          id: file.id,
          fileName: fileName,
          downloadUrl: file.downloadUrl,
          displayName: file.nome,
        ));
      } else {
        files.add(ArquivoViewModel.withTask(
          id: file.id!,
          displayName: file.nome,
          fileName: fileName,
          downloadUrl: file.downloadUrl!,
          task: tasks[index],
        ));
      }
    });
  }

  @action
  Future<void> deleteFile(ArquivoViewModel file) async {
    files.remove(file);
    _repository
        .deleteFileInsideConsulta(
          idArquivo: file.id!,
          idConsulta: consulta.id,
          situacao: consulta.situacao,
        )
        .then((_) => _minhasConsultasStore.fetchAllConsultas())
        .then((_) => navigateToHome());
    if (file.taskId != null) {
      return FlutterDownloader.remove(
        taskId: file.taskId!,
        shouldDeleteContent: true,
      );
    }
  }

  Future<void> openFile(ArquivoViewModel file) {
    return FlutterDownloader.open(taskId: file.taskId!);
  }

  Future<void> retryDownload(ArquivoViewModel file) async {
    final newTaskId = await FlutterDownloader.retry(taskId: file.taskId!);
    files.changeFileTaskId(file: file, newTaskId: newTaskId!);
  }

  @action
  Future<void> requestDownload(ArquivoViewModel file) async {
    late StreamSubscription subscription;
    final fileIndex = files.indexOf(file);
    subscription = _downloadService.downloadProgress.listen((feedback) {
      files.changeFileStatus(index: fileIndex, newStatus: feedback.status);
      if (feedback.status == DownloadTaskStatus.complete) {
        files.changeFileTaskId(index: fileIndex, newTaskId: feedback.taskId);
        subscription.cancel();
      }
    });
    return makeAsyncRequest(() => _downloadService.download(
          downloadUrl: file.downloadUrl!,
          fileName: file.fileName,
        ));
  }

  @action
  Future selectMultFiles() async {
    result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      uploadFiles!.clear();
      List<PlatformFile> files = result!.files;
      files.forEach((e) {
        uploadFiles?.add(e);
      });
    }
  }

  Future uploadStorageFile(ConsultaViewModel consulta) async {
    uploadFiles?.forEach((e) {
      var idArquivo = DateTime.now().toIso8601String() + '--' + e.name;
      destination = '$situacao/${consulta.id}/$idArquivo';
      task = FirebaseApi.uploadFile(destination, File('${e.path}'));
    });

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    url = '$urlDownload';

  }

  @action
  Future<dynamic> uploadArquivoApoio(ConsultaViewModel consulta, SituacaoConsulta situacao) async{
    String? result;
    var _db = _repository.db;

    if (situacao == SituacaoConsulta.pendente) {
      result = 'liberar';
    }
    if (situacao == SituacaoConsulta.andamento) {
      result = 'ativas';
    }

    var refLiberarArquivo =
        _db.child('consultas/$result/${consulta.id}/ArquivosApoio');

    setFiles(PlatformFile e) {
      return {
        'Nome': e.name,
        'Tamanho': e.size,
        'Tipo': e.extension,
        'Url': url,
        'Data': DateTime.now().millisecondsSinceEpoch,
        'FullPath':
            '${result}/${consulta.id}/${DateTime.now().toIso8601String() + '--' + e.name}',
      };
    }

    return makeAsyncRequest(() async {
      await uploadStorageFile(consulta).then((_) => uploadFiles!.forEach((file) {
      refLiberarArquivo
          .push()
          .set(setFiles(file))
          .then((value) => uploadFiles!.clear())
          .then((value) => navigateToHome());
      }));
    });
  }

  @action
  Future<dynamic> alunoEscolheOrcamento(var idOrcamento) async{
    var _db = _repository.db;
    final pathOrcamento = _db.child('consultas').child('ativas').
      child('${consulta.id}').child('Orcamentos').child(idOrcamento);

    return makeAsyncRequest(() async {
      await pathOrcamento.update(setOrcamento());
    }).then((results) async {
      navigateToHome();
    });
  }

  setOrcamento(){
    return {
      'Escolhido': true,
    };
  }

  void navigateToHome() {
    Modular.to.pushReplacementNamed('/home');
  }
  
  void dispose() {
    _downloadService.dispose();
  }
}
