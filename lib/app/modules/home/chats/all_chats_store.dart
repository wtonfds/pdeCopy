import 'dart:async';

import 'package:app_pde/app/models/chat.dart';
import 'package:app_pde/app/models/materia.dart';
import 'package:app_pde/app/modules/home/chats/view_models/chat_view_model.dart';
import 'package:app_pde/app/repositories/chat_repository.dart';
import 'package:app_pde/app/repositories/firebase_repository.dart';
import 'package:app_pde/app/shared/controllers/base_store.dart';
import 'package:app_pde/app/shared/controllers/materias_store.dart';
import 'package:app_pde/app/shared/utlis/device_utils.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'all_chats_store.g.dart';

class AllChatsStore = _AllChatsStoreBase with _$AllChatsStore;

abstract class _AllChatsStoreBase extends BaseStore with Store {
  final FirebaseRepository _repository;
  final ChatRepository _chatRepository;
  final MateriasStore _materiasStore;
  final bool isAluno;

  _AllChatsStoreBase(
    this._repository,
    this._materiasStore,
    this._chatRepository,
    this.isAluno,
  );

  @observable
  ObservableList<ChatViewModel> chats = ObservableList();

  @observable
  ObservableSet<String> downloadedFilesPaths = ObservableSet();

  void pushome() =>
      Modular.to.pushReplacementNamed(isAluno ? '/home' : '/professor');

  Future<void> fetchNecessaryData() {
    return makeAsyncRequest(getDownloadedFiles);
  }

  @action
  Future<List<String>?> getDownloadedFiles() {
    return DeviceUtils().getDownloadedFilesPaths().then((value) {
      if (value != null) {
        downloadedFilesPaths.addAll(value);
        return value;
      }
    });
  }

  @action
  Future<void> fetchUserChats() {
    return makeAsyncRequest(() =>
            _chatRepository.getChats(path: isAluno ? 'IDAluno' : 'IDProfessor'))
        .then((results) {
      if (results == null) return [];
      chats =
          _chatsComMateria(materias: _materiasStore.materias, chats: results)
              .asObservable();
    });
  }

  List<ChatViewModel> _chatsComMateria({
    required List<Materia> materias,
    required List<Chat> chats,
  }) {
    return chats
        .map((chat) => ChatViewModel.fromDomain(
              chat,
              nomeMateria: materias
                      .singleWhere((element) => element.id == chat.idMateria)
                      .nome ??
                  'Desconhecido',
            ))
        .toList()
          ..sort((a, b) {
            return b.concluido ? -1 : 1;
          })
          ..sort((a, b) {
            if (a.ultimaMensagem != null && b.ultimaMensagem != null) {
              return b.ultimaMensagem!.timestamp
                  .compareTo(a.ultimaMensagem!.timestamp);
            } else
              return -1;
          });
  }

  void pushChatPage(ChatViewModel chat) {
    Modular.to
        .pushNamed('mensagens/${chat.idNumerico}/chat', arguments: chat)
        .then((_) => fetchUserChats());
  }
}
