import 'package:app_pde/app/modules/cadastro_consulta_aluno/cadastro_consulta_aluno_page.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/minhas_consultas_aluno_page.dart';
import 'package:flutter/material.dart';

class BottomNavigationRoute {
  final String labelText;
  final IconData icon;
  final String routeName;
  final Widget child;

  const BottomNavigationRoute({
    required this.labelText,
    required this.icon,
    required this.routeName,
    required this.child,
  });
}

const allBottomNavigationRoutes = [
  BottomNavigationRoute(
    labelText: 'Minhas consultas',
    icon: Icons.list_alt,
    routeName: 'minhas-consultas',
    child: MinhasConsultasAlunoPage(),
  ),
  BottomNavigationRoute(
    labelText: 'Novo agendamento',
    icon: Icons.add,
    routeName: 'cadastrar-consulta',
    child: CadastrarConsultaAlunoPage(),
  ),
];
