import 'package:app_pde/app/models/bad_message.dart';
import 'package:app_pde/app/models/chat.dart';
import 'package:app_pde/app/models/dtos/bad_message_dto.dart';
import 'package:app_pde/app/models/dtos/chat_dto.dart';
import 'package:app_pde/app/models/dtos/mensagem_dto.dart';
import 'package:app_pde/app/models/mensagem.dart';
import 'package:app_pde/app/shared/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _db;

  DatabaseReference get db => _db.reference();

  const ChatRepository(this._firebaseAuth, this._db);

  Future<List<Chat>> getChats({required String path}) async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      final snapshot =
          await db.child('chats').orderByChild(path).equalTo(userId).once();
      if (snapshot.value == null) return [];
      final json = Map<String, dynamic>.from(snapshot.value);
      final chats = json.entries.map((e) {
        final chatDTO = ChatDTO.fromJson(e.value).copyWith(id: e.key);
        final reorderedChatDTO = chatDTO.copyWith(
          mensagens: chatDTO.mensagens
            ?..sort(
              (previous, next) => next.timestamp.compareTo(previous.timestamp),
            ),
        );
        return reorderedChatDTO.toDomain();
      }).toList();
      return chats;
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Stream<List<Mensagem>> watchChatMessages(String chatId) {
    try {
      return db
          .child('chats')
          .child(chatId)
          .child('messages')
          .orderByChild('timestamp')
          .onValue
          .map((event) {
        if (event.snapshot.value == null) return [];
        final json = Map<String, dynamic>.from(event.snapshot.value);
        final list = json.entries.map((e) {
          final mensagemDTO = MensagemDTO.fromJson(e.value).copyWith(id: e.key);
          return mensagemDTO.toDomain();
        }).toList();
        return List.from(list.reversed);
      });
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Future<String> addMessage(Mensagem mensagem, {required String chatId}) async {
    try {
      final mensagemDTO = MensagemDTO.fromDomain(mensagem);
      final messageRef =
          db.child('chats').child(chatId).child('messages').push();
      await messageRef.set(mensagemDTO.toJson());
      return messageRef.key;
    } catch (e) {
      print(e);
      throw (Failure(e.toString()));
    }
  }

  Future<void> addBadMessage(BadMessage badMessage) {
    try {
      final badMessageDTO = BadMessageDTO.fromDomain(badMessage);
      return db
          .child('chats')
          .child('badChats')
          .child(badMessage.id)
          .set(badMessageDTO.toJson());
    } catch (e) {
      print(e);
      throw (Failure(e.toString()));
    }
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required List<String> messagesIds,
  }) async {
    try {
      for (final messageId in messagesIds) {
        db
            .child('chats')
            .child(chatId)
            .child('messages')
            .child(messageId)
            .child('readed')
            .set(true);
      }
    } catch (e) {
      print(e);
      throw (Failure(e.toString()));
    }
  }

  Future<void> updateAttachmentAfterUpload({
    required String downloadUrl,
    required String storagePath,
    required int fileIndex,
    required String chatId,
    required String messageId,
  }) async {
    try {
      return db
          .child('chats')
          .child(chatId)
          .child('messages')
          .child(messageId)
          .child('filesMD')
          .child(fileIndex.toString())
          .update({
        'FullPath': storagePath,
        'Url': downloadUrl,
      });
    } catch (e) {
      print(e);
      throw (Failure(e.toString()));
    }
  }
}
