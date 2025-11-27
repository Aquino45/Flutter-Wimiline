import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/core/utils/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile_model.dart';
import '../../../core/utils/session_helper.dart'; // 👈 Importa el helper

class ProfileService {
  final String _url = "http://26.246.241.197:8081/api/usuarios/me/perfil";

Future<UserProfile?> getUserProfile() async {
    try {
      // ✅ CAMBIO: Leer del almacenamiento seguro
      final token = await TokenService.getToken();

      if (token == null) return null;

      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


      if (response.statusCode == 401 || response.statusCode == 403) {

        await SessionHelper.logout();
        return null;
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}