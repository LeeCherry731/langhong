import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  static final storage =  FlutterSecureStorage();

  static const keyUserName = 'username';
  static const keyPassword = 'password';

  static Future setUserName(String username) async =>
      await storage.write(key: keyUserName, value: username);

  static Future<String?> getUserName() async =>
      await storage.read(key: keyUserName);

  static Future setPassword(String password) async =>
      await storage.write(key: keyPassword, value: password);

  static Future<String?> getPassword() async =>
      await storage.read(key: keyPassword);
}
