import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveToken({required String type, required String token}) async {
    await storage.write(key: type, value: token);
  }

  Future<String> getToken(String type) async {
    return await storage.read(key: type) ?? '';
  }

  Future<void> emptyStorage() async {
    await storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final checkToken = await getToken("refresh");
    return checkToken.isNotEmpty;
  }
}
