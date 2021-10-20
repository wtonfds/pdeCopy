// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalhes_consulta_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DetalhesConsultaStore on _DetalhesConsultaStoreBase, Store {
  final _$uploadFilesAtom =
      Atom(name: '_DetalhesConsultaStoreBase.uploadFiles');

  @override
  ObservableList<PlatformFile>? get uploadFiles {
    _$uploadFilesAtom.reportRead();
    return super.uploadFiles;
  }

  @override
  set uploadFiles(ObservableList<PlatformFile>? value) {
    _$uploadFilesAtom.reportWrite(value, super.uploadFiles, () {
      super.uploadFiles = value;
    });
  }

  final _$filesAtom = Atom(name: '_DetalhesConsultaStoreBase.files');

  @override
  ArquivoObservableList get files {
    _$filesAtom.reportRead();
    return super.files;
  }

  @override
  set files(ArquivoObservableList value) {
    _$filesAtom.reportWrite(value, super.files, () {
      super.files = value;
    });
  }

  final _$statusListAtom = Atom(name: '_DetalhesConsultaStoreBase.statusList');

  @override
  bool get statusList {
    _$statusListAtom.reportRead();
    return super.statusList;
  }

  @override
  set statusList(bool value) {
    _$statusListAtom.reportWrite(value, super.statusList, () {
      super.statusList = value;
    });
  }

  final _$orcamentosAtom = Atom(name: '_DetalhesConsultaStoreBase.orcamentos');

  @override
  ObservableList<OrcamentoViewModel> get orcamentos {
    _$orcamentosAtom.reportRead();
    return super.orcamentos;
  }

  @override
  set orcamentos(ObservableList<OrcamentoViewModel> value) {
    _$orcamentosAtom.reportWrite(value, super.orcamentos, () {
      super.orcamentos = value;
    });
  }

  final _$formKeyAtom = Atom(name: '_DetalhesConsultaStoreBase.formKey');

  @override
  GlobalKey<FormState> get formKey {
    _$formKeyAtom.reportRead();
    return super.formKey;
  }

  @override
  set formKey(GlobalKey<FormState> value) {
    _$formKeyAtom.reportWrite(value, super.formKey, () {
      super.formKey = value;
    });
  }

  final _$setAvaliarConsultaAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.setAvaliarConsulta');

  @override
  Future<void> setAvaliarConsulta(int estrelas) {
    return _$setAvaliarConsultaAsyncAction
        .run(() => super.setAvaliarConsulta(estrelas));
  }

  final _$loadOrcamentosAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.loadOrcamentos');

  @override
  Future<void> loadOrcamentos({required List<Orcamento>? viewOrcamentos}) {
    return _$loadOrcamentosAsyncAction
        .run(() => super.loadOrcamentos(viewOrcamentos: viewOrcamentos));
  }

  final _$loadDownloadedFilesAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.loadDownloadedFiles');

  @override
  Future<void> loadDownloadedFiles({required List<Arquivo> viewFiles}) {
    return _$loadDownloadedFilesAsyncAction
        .run(() => super.loadDownloadedFiles(viewFiles: viewFiles));
  }

  final _$deleteFileAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.deleteFile');

  @override
  Future<void> deleteFile(ArquivoViewModel file) {
    return _$deleteFileAsyncAction.run(() => super.deleteFile(file));
  }

  final _$requestDownloadAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.requestDownload');

  @override
  Future<void> requestDownload(ArquivoViewModel file) {
    return _$requestDownloadAsyncAction.run(() => super.requestDownload(file));
  }

  final _$selectMultFilesAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.selectMultFiles');

  @override
  Future<dynamic> selectMultFiles() {
    return _$selectMultFilesAsyncAction.run(() => super.selectMultFiles());
  }

  final _$uploadArquivoApoioAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.uploadArquivoApoio');

  @override
  Future<dynamic> uploadArquivoApoio(
      ConsultaViewModel consulta, SituacaoConsulta situacao) {
    return _$uploadArquivoApoioAsyncAction
        .run(() => super.uploadArquivoApoio(consulta, situacao));
  }

  final _$alunoEscolheOrcamentoAsyncAction =
      AsyncAction('_DetalhesConsultaStoreBase.alunoEscolheOrcamento');

  @override
  Future<dynamic> alunoEscolheOrcamento(dynamic idOrcamento) {
    return _$alunoEscolheOrcamentoAsyncAction
        .run(() => super.alunoEscolheOrcamento(idOrcamento));
  }

  @override
  String toString() {
    return '''
uploadFiles: ${uploadFiles},
files: ${files},
statusList: ${statusList},
orcamentos: ${orcamentos},
formKey: ${formKey}
    ''';
  }
}
