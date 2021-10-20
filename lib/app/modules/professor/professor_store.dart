import 'package:app_pde/app/models/consulta.dart';
import 'package:app_pde/app/models/materia.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/consulta_view_model.dart';
import 'package:app_pde/app/repositories/professor_repository.dart';
import 'package:app_pde/app/shared/controllers/base_store.dart';
import 'package:app_pde/app/shared/controllers/materias_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'professor_store.g.dart';

class ProfessorStore = _ProfessorStoreBase with _$ProfessorStore;

abstract class _ProfessorStoreBase extends BaseStore with Store {
  final ProfessorRepository _repository;
  final MateriasStore _materiasStore;

  _ProfessorStoreBase(this._repository, this._materiasStore);

  Future<void> pushDetalhesConsultaPage(ConsultaViewModel consulta) {
    return Modular.to.pushNamed(
        '/professor/consultas/${consulta.idNumerico}/detalhes',
        arguments: consulta);
  }

  Future<void> fetchNecessaryData() {
    return _materiasStore
        .fetchMaterias()
        .then((_) => getConsultasProfessor());
  }

  @action
  Future<void> getConsultasProfessor() async {
    return makeAsyncRequest(() {
      return Future.wait([
        _repository.getConsultasLiberadas(),
        _repository.getConsultasDoProfessor(),
        _repository.getConsultasConcluidasProfessor(),
      ]);
    }).then((results) async {
      if (results == null) return;
      final id = Modular.get<FirebaseAuth>().currentUser!.uid;
      final consultas = results
          .expand((element) => element)
          .where((e) => e.professoresBanidos!
          .where((p) => (p.id == id) && (p.banido == true))
          .isEmpty)
          .toList();

      _consultas = _consultasComMateria(
          materias: _materiasStore.materias, consultas: consultas)
          .asObservable();
    });
  }

  List<ConsultaViewModel> _consultasComMateria(
      {required List<Materia> materias, required List<Consulta> consultas}) {
    return consultas.map((consulta) {
      final materia = materias.singleWhere(
            (materia) => materia.id == consulta.idMateria,
      );
      return ConsultaViewModel.professor(
        consulta,
        idMateria: materia.id,
        nomeMateria: materia.nome ?? 'Desconhecido',
      );
    }).toList();
  }

  @observable
  ObservableList<ConsultaViewModel> _consultas = ObservableList();

  @computed
  List<ConsultaViewModel> get consultasDisponiveis => _consultas
      .where((element) => element.situacao == SituacaoConsulta.disponiveis)
      .toList();

  @computed
  List<ConsultaViewModel> get consultasAtendidas => _consultas
      .where((element) => element.situacao == SituacaoConsulta.agendadas)
      .toList();

  @computed
  List<ConsultaViewModel> get consultasConcluidas => _consultas
      .where((element) => element.situacao == SituacaoConsulta.finalizada)
      .toList();

  @computed
  List<ConsultaViewModel> get consultasOrcadas => _consultas
      .where((element) => element.situacao == SituacaoConsulta.orcadas)
      .toList();
}


abstract class UserConsultasStore extends BaseStore {
  Future<void> fetchAllConsultas();
  void pushDetalhesConsultaPage(ConsultaViewModel consulta);
}