import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> write({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  Future<String> read(String key) async {
    return await storage.read(key: key) ?? '';
  }

  Future<void> emptyStorage() async {
    await storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final checkToken = await read("refresh");
    return checkToken.isNotEmpty;
  }
}
