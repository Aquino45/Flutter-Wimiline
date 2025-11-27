import 'dart:convert';
import 'dart:io'; // Para detectar falta de internet
import 'package:http/http.dart' as http;

import '../domain/login_repository.dart';
import '../domain/usuario_login.dart';
import 'usuario_login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  // Recuerda usar 10.0.2.2 para emulador
  final String baseUrl = "http://26.246.241.197:8081/api/auth";

  @override
  Future<String> login(UsuarioLogin user) async {
    final model = UsuarioLoginModel(
      email: user.email,
      password: user.password,
    );

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      );

      final json = jsonDecode(response.body);


      if (response.statusCode == 200) {
        return json["token"] ?? "";
      } 
      else if (response.statusCode == 401) {

        throw json["message"] ?? "Credenciales incorrectas";
      } 

      else if (response.statusCode == 400) {
        throw json["message"] ?? "Datos incorrectos";
      }

      else if (response.statusCode >= 500) {
        throw "Error interno del servidor. Intenta más tarde.";
      }
      else {
        throw "Error inesperado (${response.statusCode})";
      }

    } on SocketException {

      throw "No se pudo conectar con el servidor. Verifica tu internet.";
    } catch (e) {

      throw e.toString().replaceAll("Exception: ", "");
    }
  }
}