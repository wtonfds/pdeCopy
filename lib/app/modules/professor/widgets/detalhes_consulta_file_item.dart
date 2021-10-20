import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_view_model.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/consulta_view_model.dart';
import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetalhesConsultaFileItem extends StatefulWidget {
  final ArquivoViewModel arquivo;
  final ConsultaViewModel consulta;
  final Function openFile;
  final Function retryDownload;
  final Function requestDownload;
  final Function dispose;

  const DetalhesConsultaFileItem(
      {Key? key,
      required this.arquivo,
      required this.consulta,
      required this.openFile,
      required this.retryDownload,
      required this.requestDownload,
      required this.dispose})
      : super(key: key);

  @override
  _DetalhesConsultaFileItemState createState() =>
      _DetalhesConsultaFileItemState();
}

class _DetalhesConsultaFileItemState extends State<DetalhesConsultaFileItem> {
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
      widget.openFile();
    } else if (widget.arquivo.status == DownloadTaskStatus.failed) {
      widget.retryDownload();
    } else if (widget.arquivo.status == DownloadTaskStatus.undefined) {
      widget.requestDownload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      title: Text(widget.arquivo.displayName),
      onTap: _handleTap,
      leading: _calculateLeadingIcon(),
      /*trailing: widget.consulta.situacao != SituacaoConsulta.finalizada? PopupMenuButton<FileOption>(
        icon: const Icon(MdiIcons.dotsHorizontal, color: AppColors.darkGrey),
        onSelected: (option) {
          option.onSelected(controller: controller, file: widget.arquivo);
        },
        itemBuilder: (context) => fileOptions
            .map((option) => PopupMenuItem(
                  child: Text(option.labelText),
                  value: option,
                ))
            .toList(),
      ) : null*/
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }
}
