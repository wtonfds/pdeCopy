import 'package:app_pde/app/shared/controllers/base_store.dart';
import 'package:app_pde/app/shared/controllers/materias_store.dart';
import 'package:app_pde/app/shared/utlis/bottom_navigation_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../repositories/firebase_repository.dart';

part 'home_aluno_store.g.dart';

class HomeAlunoStore = _HomeStoreBase with _$HomeAlunoStore;

abstract class _HomeStoreBase extends BaseStore with Store {
  final FirebaseRepository _repository;
  final MateriasStore _materiasStore;

  _HomeStoreBase(this._repository, this._materiasStore);

  @observable
  int currentPageIndex = 0;

  @action
  void changePage(int index) {
    currentPageIndex = index;
    return Modular.to.navigate(allBottomNavigationRoutes[index].routeName);
  }

  Future<void> fetchNecessaryData() {
    return makeAsyncRequest(() => _materiasStore.fetchMaterias());
  }
}
