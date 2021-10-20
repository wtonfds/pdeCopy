import 'package:app_pde/app/models/aluno.dart';
import 'package:app_pde/app/models/consulta.dart';
import 'package:app_pde/app/models/dtos/materia_dto.dart';
import 'package:app_pde/app/models/dtos/usuario_dto.dart';
import 'package:app_pde/app/models/materia.dart';
import 'package:app_pde/app/models/usuario.dart';
import 'package:app_pde/app/shared/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRepository {
  final FirebaseDatabase _db;
  final FirebaseAuth _firebaseAuth;

  const FirebaseRepository(this._db, this._firebaseAuth);

  DatabaseReference get db => _db.reference();

  Future<Usuario?> getUser() async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      var snapshot = await db.child('users/alunos/$userId').once();
      if (snapshot.value == null) {
        snapshot = await db.child('users/professores/$userId').once();
      }
      final json = Map<String, dynamic>.from(snapshot.value);
      final usuarioDTO = UsuarioDTO.fromJson(json).copyWith(id: snapshot.key);
      return usuarioDTO.toDomain();
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  // Future<List<Materia>> getMateriasId(List<String> materiasId) async {
  //   try {
  //     final List<Materia> result = [];
  //     materiasId.map((e) async {
  //       final snapshot = await db.child('materias/$e').once();
  //       final materiaDTO =
  //           MateriaDTO.fromJson(snapshot.value).copyWith(id: snapshot.key);
  //       result.add(materiaDTO.toDomain());
  //     });
  //     return result;
  //   } catch (e) {
  //     print(e);
  //     throw Failure(e.toString());
  //   }
  // }

  Future<List<Materia>> getMaterias() async {
    try {
      final snapshot = await db.child('materias').once();
      final json = Map<String, dynamic>.from(snapshot.value);
      return json.entries.map((e) {
        final materiaJson = Map<String, dynamic>.from(e.value);
        final materiaDTO = MateriaDTO.fromJson(materiaJson).copyWith(id: e.key);
        return materiaDTO.toDomain();
      }).toList();
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Future<void> updateUser(Usuario user) async {
    try {
      final path = user is Aluno ? 'users/alunos' : 'users/professores';
      final usuarioDTO = UsuarioDTO.fromDomain(user);
      final userId = _firebaseAuth.currentUser!.uid;
      return db.child(path).child(userId).update(usuarioDTO.toJson());
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Future<void> deleteFileInsideConsulta({
    required String idArquivo,
    required String idConsulta,
    required SituacaoConsulta situacao,
  }) async {
    late String path;
    switch (situacao) {
      case SituacaoConsulta.andamento:
        path = 'ativas';
        break;
      case SituacaoConsulta.pendente:
        path = 'liberar';
        break;
      case SituacaoConsulta.finalizada:
        path = 'concluidas';
        break;
      default:
        path = 'concluidas';
    }

    try {
      return db
          .child('consultas')
          .child(path)
          .child(idConsulta)
          .child('ArquivosApoio')
          .child(idArquivo)
          .remove();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> setAvaliarConsulta(String id, int estrelas) async {
    try {
      final TransactionResult transactionResult = await db
          .child('consultas/concluidas/$id')
          .runTransaction((MutableData mutableData) async {
        if (mutableData.value != null) {
          if (mutableData.value['Estrelas'] == null) {
            mutableData.value['Estrelas'] = estrelas;
          }
        }
        return mutableData;
      });

      if (transactionResult.committed) {
        return true;
      } else {
        if (transactionResult.error != null) {
          print(transactionResult.error!.message);
        }
        return false;
      }
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }
}
