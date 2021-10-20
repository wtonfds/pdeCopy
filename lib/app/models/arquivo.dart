import 'package:equatable/equatable.dart';

class Arquivo extends Equatable {
  final String? id;
  final String nome;
  final String? downloadUrl;
  final String storagePath;
  final String? devicePath;
  final int? size;
  final String? fileExtension;

  final DateTime timestamp;

  const Arquivo({
    this.id,
    required this.nome,
    this.downloadUrl,
    required this.storagePath,
    required this.timestamp,
    this.devicePath,
    this.size,
    this.fileExtension,
  });

  @override
  List<Object?> get props => [
        id,
        nome,
        downloadUrl,
        storagePath,
        timestamp,
        devicePath,
        size,
        fileExtension,
      ];
}
