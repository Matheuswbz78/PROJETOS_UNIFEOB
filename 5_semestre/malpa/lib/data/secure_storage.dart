import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: 'jwt_token', value: token);
      print("Token saved successfully.");
    } catch (e) {
      print("Error saving token: $e");
    }
  }

  static Future<String?> getToken() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        print("Token not found.");
      } else {
        print("Token retrieved successfully.");
      }
      return token;
    } catch (e) {
      print("Error reading token: $e");
      return null;
    }
  }

  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: 'jwt_token');
      print("Token deleted successfully.");
    } catch (e) {
      print("Error deleting token: $e");
    }
  }

  // Adicione esta função para verificar se o token existe
  static Future<bool> tokenExists() async {
    String? token = await getToken();
    return token != null; // Retorna verdadeiro se token não é nulo
  }
}
