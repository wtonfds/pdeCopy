import 'package:app_pde/app/models/consulta.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/detalhes_consulta_store.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_view_model.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/consulta_view_model.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/file_options.dart';
import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetalhesConsultaFileItem extends StatefulWidget {
  final ArquivoViewModel arquivo;
  final ConsultaViewModel consulta;

  const DetalhesConsultaFileItem(this.arquivo, this.consulta, {Key? key})
      : super(key: key);

  @override
  _DetalhesConsultaFileItemState createState() =>
      _DetalhesConsultaFileItemState();
}

class _DetalhesConsultaFileItemState
    extends ModularState<DetalhesConsultaFileItem, DetalhesConsultaStore> {
  List<FileOption> _calculateFileOptions() {
    if (widget.consulta.situacao == SituacaoConsulta.pendente) {
      return const [DeleteFileOption()];
    }
    return [];
  }

  Widget _calculateLeadingIcon() {
    if (widget.arquivo.status == DownloadTaskStatus.complete) {
      return const Icon(MdiIcons.checkCircle, color: AppColors.success);
    } else if (widget.arquivo.status == DownloadTaskStatus.failed) {
      return const Icon(MdiIcons.replay, color: AppColors.error);
    } else if (widget.arquivo.status == DownloadTaskStatus.undefined) {
      return const Icon(MdiIcons.download, color: AppColors.primary);
    } else {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
    }
  }

  void _handleTap() {
    if (widget.arquivo.status == DownloadTaskStatus.complete) {
      controller.openFile(widget.arquivo);
    } else if (widget.arquivo.status == DownloadTaskStatus.failed) {
      controller.retryDownload(widget.arquivo);
    } else if (widget.arquivo.status == DownloadTaskStatus.undefined) {
      controller.requestDownload(widget.arquivo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileOptions = _calculateFileOptions();
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        title: Text(widget.arquivo.displayName),
        onTap: _handleTap,
        leading: _calculateLeadingIcon(),
        trailing: fileOptions.isEmpty
            ? null
            : PopupMenuButton<FileOption>(
                icon: const Icon(MdiIcons.dotsHorizontal,
                    color: AppColors.darkGrey),
                onSelected: (option) {
                  option.onSelected(controller: controller, file: widget.arquivo);
                },
                itemBuilder: (context) => fileOptions
                    .map((option) => PopupMenuItem(
                          child: Text(option.labelText),
                          value: option,
                        ))
                    .toList(),
              ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
