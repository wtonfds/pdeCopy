import 'dart:async';

import 'package:app_pde/app/modules/home/chats/all_chats_store.dart';
import 'package:app_pde/app/modules/home/chats/current_chat_store.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_view_model.dart';
import 'package:app_pde/app/shared/controllers/base_store.dart';
import 'package:app_pde/app/shared/utlis/download_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:open_file/open_file.dart';

part 'chat_download_store.g.dart';

class ChatDownloadStore = _ChatDownloadStoreBase with _$ChatDownloadStore;

abstract class _ChatDownloadStoreBase extends BaseStore
    with Store
    implements Disposable {
  final DownloadService _downloadService;

  _ChatDownloadStoreBase(this._downloadService) {
    _downloadSubscription = _downloadService.downloadProgress.listen((event) {
      if (event.status == DownloadTaskStatus.complete) {
        Modular.get<AllChatsStore>()
            .getDownloadedFiles()
            .then((_) => Modular.get<CurrentChatStore>().watchChatMessages());
      }
    });
  }

  StreamSubscription? _downloadSubscription;

  Future<void> requestDownload(ArquivoViewModel file) async {
    return makeAsyncRequest(
      () => _downloadService.download(
        downloadUrl: file.downloadUrl!,
        fileName: file.fileName,
      ),
    );
  }

  Future<void> openFile(ArquivoViewModel file) async {
    if (file.devicePath != null) {
      final result = await OpenFile.open(file.devicePath ?? '');
      if (result.type == ResultType.fileNotFound) {
        _tryAnotherOpenMethod(file);
      }
    } else {
      final result = await _tryAnotherOpenMethod(file);
      if (!result) return requestDownload(file);
    }
  }

  Future<bool> _tryAnotherOpenMethod(ArquivoViewModel file) async {
    final query = "SELECT * FROM task WHERE file_name='${file.fileName}'";
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
    if (tasks!.isNotEmpty) {
      return FlutterDownloader.open(taskId: tasks.first.taskId);
    }
    return false;
  }

  @override
  void dispose() {
    _downloadService.dispose();
    _downloadSubscription?.cancel();
  }
}
