import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  static const _token = 'token';

  Future<void> saveToken({required String token}) async {
    await storage.write(key: _token, value: token);
  }

  Future<String> getToken() async {
    return await storage.read(key: _token) ?? '';
  }

  Future<bool> isLoggedIn() async {
    final checkToken = await getToken();
    return checkToken.isNotEmpty;
  }
}
