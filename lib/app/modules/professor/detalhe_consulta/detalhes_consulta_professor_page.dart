import 'dart:convert';

import 'package:app_pde/app/models/consulta.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/consulta_view_model.dart';
import 'package:app_pde/app/modules/professor/widgets/detalhes_consulta_file_item.dart';
import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:app_pde/app/shared/widgets/app_scaffold.dart';
import 'package:app_pde/app/shared/widgets/custom_card.dart';
import 'package:app_pde/app/shared/widgets/custom_load_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'detalhes_consulta_professor_store.dart';

class DetalhesConsultaProfessorPage extends StatefulWidget {
  final ConsultaViewModel consulta;

  const DetalhesConsultaProfessorPage(this.consulta, {Key? key})
      : super(key: key);

  @override
  State<DetalhesConsultaProfessorPage> createState() =>
      _DetalhesConsultaProfessorPageState();
}

class _DetalhesConsultaProfessorPageState extends ModularState<
    DetalhesConsultaProfessorPage, DetalhesConsultaProfessorStore> {

  @override
  void initState() {
    super.initState();
    controller.consulta = widget.consulta;
    controller.loadDownloadedFiles(viewFiles: widget.consulta.arquivos);

  }

  Map<String, dynamic> _buildDetails() {
    List<dynamic> listTipos = [];
    final Map<String?, dynamic>? _tipoArquivoResposta = widget.consulta.tipoArquivoResposta;

    if(_tipoArquivoResposta!.containsValue(true)){
     listTipos.add(_tipoArquivoResposta.entries.where((e) => e.value == true));
    }

    var newListTipos = listTipos.toString().replaceAll('[(MapEntry(', '')
        .replaceAll(': true', '').replaceAll('MapEntry(', '').replaceAll(')', '')
        .replaceAll('(', '').replaceAll('))]', '').replaceAll(']', '').replaceAll(']', '');

    return {
      'Matéria': widget.consulta.nomeMateria,
      'Data': widget.consulta.dataInicio,
      'Hora': widget.consulta.hora,
      'Valor da consulta': widget.consulta.valor,
      'Observações': widget.consulta.obs,
      'Numero de questões' : widget.consulta.numeroQuestoes!.isEmpty
          ? 'Não informado' : widget.consulta.numeroQuestoes,
      'Software de resposta': widget.consulta.softwareResposta!.isEmpty
          ? 'Não informado' : widget.consulta.softwareResposta,
      'Valores Especificos' : widget.consulta.valEspecifico!.isEmpty
          ? 'Não informado' : widget.consulta.valEspecifico,
      'Tipos de arquivos resposta' : widget.consulta.tipoArquivoResposta == null
          ? 'Não informado' : newListTipos,
    };
  }

  Future<void> _messagemPegarConsulta(ConsultaViewModel consulta) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Confirma que deseja reservar essa consulta?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
            'Lembre-se que está se comprometendo à uma consulta, com desistência em até 24 horas antes do início agendado.',
            style: TextStyle(fontSize: 14)),
        actions: [
          CustomLoadButton(
              loading: controller.loading,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green.shade600)),
              onPressed: () {
                Modular.to.pop();
                controller.setProfessorConsulta(context, consulta);
              },
              title: 'Sim'),
          CustomLoadButton(
            loading: controller.loading,
            onPressed: () => Modular.to.pop(),
            title: 'Não',
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isScrollable: true,
      title: 'Detalhes #${widget.consulta.idNumerico}',
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildStatusCard(),
          const SizedBox(height: 48),
          _buildSectionHeader('Informações'),
          const SizedBox(height: 12),
          ..._buildDetails()
              .entries
              .map((detail) => _buildDetailItem(detail))
              .toList(),
          const SizedBox(height: 48),
          _buildSectionHeader('Arquivos'),
          _buildFileItems(),
          const SizedBox(height: 12),
          _buildButtonPressed(context, widget.consulta),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'STATUS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.consulta.color,
                ),
                height: 8,
                width: 8,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.consulta.status,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(MapEntry<String, dynamic> e) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            e.key,
            style: const TextStyle(color: AppColors.grey, fontSize: 16),
          ),
          const Spacer(),
          Expanded(
            flex: 4,
            child: Text(
              e.value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Icon(MdiIcons.circle, size: 8),
          const SizedBox(width: 12),
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonPressed(context, ConsultaViewModel consulta) {
    return consulta.situacao == SituacaoConsulta.disponiveis
        ? Column(
            children: [
              widget.consulta.isOrcamento == true ? _buildPegarConsulta(
                  text: 'Orçar Consulta',
                  onPressed: () {
                    controller.pushOrcamentoPage(consulta);
                  }) : _buildPegarConsulta(
                  text: 'Pegar Consulta',
                  onPressed: () => _messagemPegarConsulta(consulta)),
              _buildPegarConsulta(
                  text: 'Não Visulizar Consulta',
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red.shade700)),
                  onPressed: () {
                    controller.setBanirProfessor(context, consulta);
                  })
            ],
          )
        : consulta.situacao == SituacaoConsulta.agendadas &&
                consulta.textCorrecao != ''
            ? _buildPegarConsulta(
                text: 'Aluno Pediu Correção',
                onPressed: () {
                  controller.pushCorrecaoConsultaPage(consulta);
                })
            : Container();
  }

  Widget _buildPegarConsulta(
      {required String text, required Function onPressed, ButtonStyle? style}) {
    return SizedBox(
      width: double.infinity,
      child: CustomLoadButton(
          style: style,
          title: text,
          loading: controller.loading,
          onPressed: () {
            onPressed();
          }),
    );
  }

  Widget _buildFileItems() {
    return Observer(
      builder: (_) => Column(
        children: controller.files
            .map((arquivo) => DetalhesConsultaFileItem(
                consulta: widget.consulta,
                arquivo: arquivo,
                openFile: () {
                  controller.openFile(arquivo);
                },
                retryDownload: () {
                  controller.retryDownload(arquivo);
                },
                requestDownload: () {
                  controller.requestDownload(arquivo);
                },
                dispose: () {
                  controller.dispose();
                }))
            .toList(),
      ),
    );
  }
}
