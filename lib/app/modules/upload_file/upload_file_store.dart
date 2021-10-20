import 'dart:async';
import 'dart:io';

import 'package:app_pde/app/models/dtos/arquivo_dto.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_view_model.dart';
import 'package:app_pde/app/modules/upload_file/utils/firebase_api.dart';
import 'package:app_pde/app/shared/utlis/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:open_file/open_file.dart';

part 'upload_file_store.g.dart';

class UploadFileStore = _UploadFileStore with _$UploadFileStore;

abstract class _UploadFileStore with Store {
  _UploadFileStore() {
    uploadFiles.observe((change) {
      badFiles = ObservableList.of(
        change.list.where((file) {
          return Constants.badFileRegex.hasMatch(file.fileExtension);
        }),
      );
    }, fireImmediately: true);
  }

  @observable
  ObservableList<ArquivoViewModel> uploadFiles = ObservableList();

  @observable
  ObservableList<ArquivoViewModel> badFiles = ObservableList();

  @action
  Future<void> selectMultFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      final mappedFiles = result.files
          .map((file) => ArquivoViewModel.fromPlatformFile(file))
          .toList();
      return uploadFiles.addAll(mappedFiles);
    }
  }

  @action
  void removeFile(ArquivoViewModel file) => uploadFiles.remove(file);

  Future<void> openFile(ArquivoViewModel file) async {
    OpenFile.open(file.devicePath ?? '');
  }

  Future<String> uploadSingleFile(
    ArquivoDTO fileDTO, {
    required String devicePath,
  }) async {
    final task = FirebaseApi.uploadFile(fileDTO.storagePath, File(devicePath));
    await task.whenComplete(() => null);
    final downloadUrl = await task.snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
