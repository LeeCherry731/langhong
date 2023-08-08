import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BioMetricsAuth {
  static final auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await auth.authenticate(
          localizedReason: 'สแกนลายนิ้วมือเข้าสู่ระบบ',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      return false;
    }
  }
}
