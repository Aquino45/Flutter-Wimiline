import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  // Instancia del almacenamiento seguro
  static const _storage = FlutterSecureStorage();
  
  static const _keyToken = 'auth_token';

  // 1. Guardar Token (Login)
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // 2. Obtener Token (Splash / Perfil)
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // 3. Eliminar Token (Logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}