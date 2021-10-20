import 'package:app_pde/app/shared/errors/failure.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthentication {
  final _localAuth = LocalAuthentication();

  Future<bool> tryAuthentication() async {
    try {
      final result = await _localAuth.authenticate(
          biometricOnly: true,
          androidAuthStrings: const AndroidAuthMessages(
              signInTitle: 'Biometria para login do Aplicativo',
              biometricHint: '',
              cancelButton: 'Cancelar'),
          iOSAuthStrings: const IOSAuthMessages(cancelButton: 'Cancelar'),
          localizedReason: "Use a biometria para prosseguir",
          useErrorDialogs: true,
          stickyAuth: true);
      return result;
    } on PlatformException catch (e) {
      print(e);
      throw const Failure('Falha na biometria');
    } catch (e) {
      print(e);
      throw const Failure('Falha desconhecida');
    }
  }

  Future<bool> isAvailable() async {
    if (await _localAuth.canCheckBiometrics &&
        await _localAuth.isDeviceSupported()) {
      final listOfBiometrics = await _localAuth.getAvailableBiometrics();
      return listOfBiometrics.contains(BiometricType.fingerprint);
    }
    return false;
  }
}
