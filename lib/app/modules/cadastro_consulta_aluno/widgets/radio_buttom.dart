import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../cadastro_consulta_aluno_store.dart';

enum SingingCharacter { ate5, ate10, maisQ10, NDA }

class RadioButtom extends StatefulWidget {
  const RadioButtom({Key? key}) : super(key: key);

  @override
  _RadioButtomState createState() => _RadioButtomState();
}

class _RadioButtomState extends ModularState<RadioButtom, CadastroConsultaAlunoStore> {

  SingingCharacter? _character = SingingCharacter.ate5;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text("Até 5 questões"),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.ate5,
            groupValue: _character,
            onChanged: (SingingCharacter? value){
              setState(() {
                _character = value;
                controller.ctrlNumeroQuestoes = '<5';
              });
            }
          ),
        ),
        ListTile(
          title: const Text("Até 10 questões"),
          leading: Radio<SingingCharacter>(
              value: SingingCharacter.ate10,
              groupValue: _character,
              onChanged: (SingingCharacter? value){
                setState(() {
                  _character = value;
                  controller.ctrlNumeroQuestoes = '10';
                });
              }
          ),
        ),
        ListTile(
          title: const Text("Mais que 10 questões"),
          leading: Radio<SingingCharacter>(
              value: SingingCharacter.maisQ10,
              groupValue: _character,
              onChanged: (SingingCharacter? value){
                setState(() {
                  _character = value;
                  controller.ctrlNumeroQuestoes = '>10';
                });
              }
          ),
        ),
        ListTile(
          title: const Text("Não sei informar"),
          leading: Radio<SingingCharacter>(
              value: SingingCharacter.NDA,
              groupValue: _character,
              onChanged: (SingingCharacter? value){
                setState(() {
                  _character = value;
                  controller.ctrlNumeroQuestoes = 'Não sei informar';
                });
              }
          ),
        ),
      ],
    );
  }
}
