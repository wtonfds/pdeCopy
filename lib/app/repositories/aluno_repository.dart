import 'package:app_pde/app/models/consulta.dart';
import 'package:app_pde/app/models/dtos/consulta_dto.dart';
import 'package:app_pde/app/repositories/firebase_repository.dart';
import 'package:app_pde/app/shared/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AlunoRepository extends FirebaseRepository {
  final FirebaseDatabase _db;
  final FirebaseAuth _firebaseAuth;

  AlunoRepository(FirebaseDatabase db, FirebaseAuth firebaseAuth)
      : _db = db,
        _firebaseAuth = firebaseAuth,
        super(db, firebaseAuth);

  Future<List<Consulta>> getConsultasFinalizadas() => _getConsultas(
        path: 'concluidas',
        situacao: SituacaoConsulta.finalizada,
      );

  Future<List<Consulta>> getConsultasAndamento() => _getConsultas(
        path: 'ativas',
        situacao: SituacaoConsulta.andamento,
      );

  Future<List<Consulta>> getConsultasPendentes() => _getConsultas(
        path: 'liberar',
        situacao: SituacaoConsulta.pendente,
      );

  Future<List<Consulta>> _getConsultas({
    required String path,
    required SituacaoConsulta situacao,
  }) async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      final snapshot = await db
          .child('consultas')
          .child(path)
          .orderByChild('IDAluno')
          .equalTo(userId)
          .once();
      if (snapshot.value == null) return [];
      final json = Map<String, dynamic>.from(snapshot.value);
      return json.entries.map((e) {
        final consultaDTO = ConsultaDTO.fromJson(e.value).copyWith(
          id: e.key,
          situacao: situacao,
        );
        return consultaDTO.toDomain();
      }).toList();
    } catch (e) {

      throw Failure(e.toString());
    }
  }

  Future<DatabaseReference> createConsulta(ConsultaDTO consultaDTO, bool isOrcamento) async {
    final incrementResult = await _incrementConsultasCounter();
    if (!incrementResult.committed) {
      throw const Failure('Erro ao salvar consulta');
    }
    final refLiberar;
    if(isOrcamento == true){
      refLiberar = db.child('consultas').child('ativas').push();
    }else{
      refLiberar = db.child('consultas').child('liberar').push();
    }
    consultaDTO = consultaDTO.copyWith(
      idNumerico: incrementResult.dataSnapshot!.value,
    );

    await refLiberar.set(consultaDTO.toJson());
    return refLiberar;
  }

  Future<TransactionResult> _incrementConsultasCounter() async {
    final counterReference = db.child('consultas').child('count');
    final transactionResult =
        await counterReference.runTransaction((MutableData count) async {
      count.value = (count.value ?? 0) + 1;
      return count;
    });
    return transactionResult;
  }
}
