import 'package:app_pde/app/modules/minhas_consultas_aluno/consulta_tab_aluno.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/minhas_consultas_store.dart';
import 'package:app_pde/app/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MinhasConsultasAlunoPage extends StatefulWidget {
  const MinhasConsultasAlunoPage();

  @override
  _MinhasConsultasAlunoPageState createState() =>
      _MinhasConsultasAlunoPageState();
}

class _MinhasConsultasAlunoPageState
    extends ModularState<MinhasConsultasAlunoPage, MinhasConsultasStore> {
  @override
  void initState() {
    super.initState();
    controller.fetchNecessaryData();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => AppScaffold(
        title: 'Minhas consultas',
        hasDrawer: true,
        isScrollable: false,
        store: controller,
        tabBar: controller.loading
            ? null
            : const TabBar(
                tabs: [
                  Tab(text: 'ANDAMENTO'),
                  Tab(text: 'PENDENTES'),
                  Tab(text: 'FINALIZADAS'),
                ],
              ),
        body: controller.loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  ConsultaTabAluno(controller.consultasAndamento),
                  ConsultaTabAluno(controller.consultasPendentes),
                  ConsultaTabAluno(controller.consultasFinalizadas),
                ],
              ),
      ),
    );
  }
}
