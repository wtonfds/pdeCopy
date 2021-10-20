// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalhes_consulta_professor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DetalhesConsultaProfessorStore
    on _DetalhesConsultaProfessorStoreBase, Store {
  final _$uploadFilesAtom =
      Atom(name: '_DetalhesConsultaProfessorStoreBase.uploadFiles');

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

  final _$filesAtom = Atom(name: '_DetalhesConsultaProfessorStoreBase.files');

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

  final _$formKeyAtom =
      Atom(name: '_DetalhesConsultaProfessorStoreBase.formKey');

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

  final _$setProfessorConsultaAsyncAction =
      AsyncAction('_DetalhesConsultaProfessorStoreBase.setProfessorConsulta');

  @override
  Future<void> setProfessorConsulta(
      dynamic context, ConsultaViewModel consulta) {
    return _$setProfessorConsultaAsyncAction
        .run(() => super.setProfessorConsulta(context, consulta));
  }

  final _$setBanirProfessorAsyncAction =
      AsyncAction('_DetalhesConsultaProfessorStoreBase.setBanirProfessor');

  @override
  Future<void> setBanirProfessor(dynamic context, ConsultaViewModel consulta) {
    return _$setBanirProfessorAsyncAction
        .run(() => super.setBanirProfessor(context, consulta));
  }

  final _$loadDownloadedFilesAsyncAction =
      AsyncAction('_DetalhesConsultaProfessorStoreBase.loadDownloadedFiles');

  @override
  Future<void> loadDownloadedFiles({required List<Arquivo> viewFiles}) {
    return _$loadDownloadedFilesAsyncAction
        .run(() => super.loadDownloadedFiles(viewFiles: viewFiles));
  }

  final _$deleteFileAsyncAction =
      AsyncAction('_DetalhesConsultaProfessorStoreBase.deleteFile');

  @override
  Future<void> deleteFile(ArquivoViewModel file) {
    return _$deleteFileAsyncAction.run(() => super.deleteFile(file));
  }

  final _$requestDownloadAsyncAction =
      AsyncAction('_DetalhesConsultaProfessorStoreBase.requestDownload');

  @override
  Future<void> requestDownload(ArquivoViewModel file) {
    return _$requestDownloadAsyncAction.run(() => super.requestDownload(file));
  }

  final _$selectMultFilesAsyncAction =
      AsyncAction('_DetalhesConsultaProfessorStoreBase.selectMultFiles');

  @override
  Future<dynamic> selectMultFiles() {
    return _$selectMultFilesAsyncAction.run(() => super.selectMultFiles());
  }

  @override
  String toString() {
    return '''
uploadFiles: ${uploadFiles},
files: ${files},
formKey: ${formKey}
    ''';
  }
}
