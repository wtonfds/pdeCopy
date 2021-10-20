import 'dart:io';

import 'package:app_pde/app/modules/home/chats/view_models/mensagem_view_model.dart';
import 'package:app_pde/app/modules/minhas_consultas_aluno/view_models/arquivo_view_model.dart';
import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:app_pde/app/shared/utlis/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MessageBalloon extends StatelessWidget {
  final MensagemViewModel mensagem;
  final void Function(ArquivoViewModel) openFileCallback;

  const MessageBalloon(
    this.mensagem, {
    Key? key,
    required this.openFileCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(Constants.defaultBorderRadius);
    return Row(
      mainAxisAlignment:
          mensagem.souEu ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding:
                const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
            decoration: BoxDecoration(
              color: mensagem.souEu ? AppColors.primaryDark : AppColors.lightGrey,
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
                bottomLeft: mensagem.souEu ? radius : Radius.zero,
                bottomRight: mensagem.souEu ? Radius.zero : radius,
              ),
            ),
            child: Column(
              crossAxisAlignment: mensagem.souEu
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  mensagem.texto,
                  style: TextStyle(
                    color: mensagem.souEu ? Colors.white : AppColors.darkGrey,
                  ),
                ),
                if (mensagem.temArquivos) _buildAttachedFiles(),
                const SizedBox(height: 4),
                Text(
                  mensagem.data,
                  style: TextStyle(
                    fontSize: 8,
                    color: mensagem.souEu
                        ? Colors.white.withOpacity(.5)
                        : AppColors.darkGrey.withOpacity(.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachedFiles() {
    return Column(
      children: mensagem.arquivos!
          .map((e) => ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: e.canDownload
                    ? _buildFileDisplay(e)
                    : const LinearProgressIndicator(),
              ))
          .toList(),
    );
  }

  Widget _buildFileDisplay(ArquivoViewModel file) {
    return GestureDetector(
      onTap: () => openFileCallback(file),
      child: Stack(
        children: [
          file.isImage ? _buildImageDisplay(file) : _buildDocumentDisplay(file),
        ],
      ),
    );
  }

  Widget _buildImageDisplay(ArquivoViewModel file) {
    return file.canOpen()
        ? Image.file(
            File(file.devicePath!),
            errorBuilder: (context, error, stackTrace) {
              return const Text('Erro ao carregar imagem');
            },
            width: 200,
            height: 200,
            cacheWidth: 200,
            fit: BoxFit.cover,
          )
        : Image.network(
            file.downloadUrl!,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Erro ao carregar imagem');
            },
            width: 200,
            height: 200,
            cacheWidth: 30,
            fit: BoxFit.cover,
          );
  }

  Widget _buildDocumentDisplay(ArquivoViewModel file) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        file.canOpen()
            ? const Icon(
                MdiIcons.file,
                color: AppColors.success,
              )
            : const Icon(
                MdiIcons.fileDownload,
                color: AppColors.accent,
              ),
        const SizedBox(width: 6),
        Text(
          file.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
