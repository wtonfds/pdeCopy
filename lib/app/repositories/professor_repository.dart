import 'package:app_pde/app/models/consulta.dart';
import 'package:app_pde/app/models/dtos/consulta_dto.dart';
import 'package:app_pde/app/models/dtos/pedido_saque_professor_dto.dart';
import 'package:app_pde/app/models/materia.dart';
import 'package:app_pde/app/models/orcamento.dart';
import 'package:app_pde/app/models/pedido_saque_professor.dart';
import 'package:app_pde/app/repositories/firebase_repository.dart';
import 'package:app_pde/app/shared/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfessorRepository extends FirebaseRepository {
  final FirebaseDatabase _db;
  final FirebaseAuth _firebaseAuth;

  ProfessorRepository(FirebaseDatabase db, FirebaseAuth firebaseAuth)
      : _db = db,
        _firebaseAuth = firebaseAuth,
        super(db, firebaseAuth);

  Future<List<Consulta>> getConsultasLiberadas() => _getConsultas(
      path: 'ativas',
      consultasEscolhasProfessor: true,
      situacao: SituacaoConsulta.disponiveis);

  Future<List<Consulta>> getConsultasDoProfessor() =>
      _getConsultas(path: 'ativas', situacao: SituacaoConsulta.agendadas);

  Future<List<Consulta>> getConsultasConcluidasProfessor() =>
      _getConsultas(path: 'concluidas', situacao: SituacaoConsulta.finalizada);

  Future<List<Consulta>> getConsultasOrcadasProfessor() => _getConsultas(
      path: 'ativas', isOrcada: true, situacao: SituacaoConsulta.orcadas);

  Future<List<Consulta>> _getConsultas({
    required String path,
    bool consultasEscolhasProfessor = false,
    required SituacaoConsulta situacao,
    bool isOrcada = false,
  }) async {
    try {
      final userId =
          consultasEscolhasProfessor ? null : _firebaseAuth.currentUser!.uid;

      final snapshot = await db
          .child('consultas')
          .child(path)
          .orderByChild('IDProfessor')
          .equalTo(userId)
          .once();

      if (snapshot.value == null) return [];
      final json = Map<String, dynamic>.from(snapshot.value);
      return json.entries.map((e) {
        final consultaDTO = ConsultaDTO.fromJson(e.value)
            .copyWith(id: e.key, situacao: situacao);
        return consultaDTO.toDomain();
      }).toList();
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Future<bool> setProfessorConsulta(String id) async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      final TransactionResult transactionResult = await db
          .child('consultas/ativas/$id')
          .runTransaction((MutableData mutableData) async {
        if (mutableData.value != null) {
          if (mutableData.value['IDProfessor'] == null) {
            mutableData.value['IDProfessor'] = userId;
          }
        }
        return mutableData;
      });

      if (transactionResult.committed) {
        return true;
      } else {
        if (transactionResult.error != null) {
          throw Failure(transactionResult.error!.message);
        }
        return false;
      }
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Future<bool> setBanirProfessor(String id) async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      final TransactionResult transactionResult = await db
          .child('consultas/ativas/$id')
          .runTransaction((MutableData mutableData) async {
        if (mutableData.value != null) {
          final Map<dynamic, dynamic> json = Map<dynamic, dynamic>();
          if (mutableData.value['ProfessoresBanidos'] != null) {
            json.addAll(mutableData.value['ProfessoresBanidos']);
          }
          json['$userId'] = true;
          mutableData.value['ProfessoresBanidos'] = json;
        }
        return mutableData;
      });

      if (transactionResult.committed) {
        return true;
      } else {
        if (transactionResult.error != null) {
          throw Failure(transactionResult.error!.message);
        }
        return false;
      }
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Future<void> requestProfessorWithdraw(PedidoSaqueProfessor pedido) {
    final pedidoDTO = PedidoSaqueProfessorDTO.fromDomain(pedido);
    try {
      return db
          .child('pedidosSaquesProf')
          .child(pedido.idProfessor)
          .set(pedidoDTO.toJson());
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }
}
