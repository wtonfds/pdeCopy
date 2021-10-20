import 'dart:io';

import 'package:app_pde/app/shared/errors/failure.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:permission_handler/permission_handler.dart';

enum PermissionType { downloadDirectory, appDirectory, none }

abstract class DeviceUtils {
  Future<String?> getDownloadFolderPath();
  Future<List<String>?> getDownloadedFilesPaths();

  factory DeviceUtils() {
    return Platform.isAndroid
        ? const _AndroidDeviceUtils()
        : const _IosDeviceUtils();
  }
}

class _AndroidDeviceUtils implements DeviceUtils {
  const _AndroidDeviceUtils();

  @override
  Future<String?> getDownloadFolderPath() async {
    try {
      final permissionType = await _checkPermission();
      if (permissionType == PermissionType.appDirectory) {
        return path.getExternalStorageDirectory().then((value) => value!.path);
      } else if (permissionType == PermissionType.downloadDirectory) {
        return _calculateDownloadDir().then((value) => value);
      }
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  Future<String> _calculateDownloadDir() async {
    final externalDir = await path.getExternalStorageDirectory();
    final dirIndex = externalDir?.path.split('/').indexOf('Android');
    final finalPath = externalDir?.path.split('/').take(dirIndex!).join('/');
    return '$finalPath/Download';
  }

  Future<PermissionType> _checkPermission() async {
    PermissionStatus status;

    if (await Permission.manageExternalStorage.isRestricted) {
      if (await Permission.storage.isGranted) {
        return PermissionType.appDirectory;
      }
      status = await Permission.storage.request();
      return status.isGranted
          ? PermissionType.appDirectory
          : PermissionType.none;
    } else {
      if (await Permission.manageExternalStorage.isGranted) {
        return PermissionType.downloadDirectory;
      }
      status = await Permission.manageExternalStorage.request();
      return status.isGranted
          ? PermissionType.downloadDirectory
          : PermissionType.none;
    }
  }

  @override
  Future<List<String>?> getDownloadedFilesPaths() async {
    List<String> files = [];
    final temp = await path.getTemporaryDirectory();
    final dir = await path.getExternalStorageDirectory();
    if (dir != null) {
      files.addAll(dir.listSync(recursive: true).map((e) => e.path).toList());
    }
    files.addAll(temp.listSync(recursive: true).map((e) => e.path).toList());
    return files;
  }
}

class _IosDeviceUtils implements DeviceUtils {
  const _IosDeviceUtils();

  @override
  Future<String?> getDownloadFolderPath() {
    try {
      return path.getApplicationDocumentsDirectory().then((dir) => dir.path);
    } catch (e) {
      print(e);
      throw Failure(e.toString());
    }
  }

  @override
  Future<List<String>?> getDownloadedFilesPaths() async {
    final dir = await path.getExternalStorageDirectory();
    if (dir != null) {
      final files = dir.listSync(recursive: true);
      return files.map((e) => e.path).toList();
    }
  }
}
