import 'package:http/http.dart' as http;
import 'dart:convert';
import '../domain/auth_repository.dart';


import '../domain/usuario.dart';
import 'usuario_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl = "http://26.246.241.197:8081/api/auth";

  @override
  Future<bool> register(Usuario usuario) async {
    final model = UsuarioModel(
      nombre: usuario.nombre,
      apellido: usuario.apellido,
      email: usuario.email,
      telefono: usuario.telefono,
      password: usuario.password,
    );

    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    final json = jsonDecode(res.body);

    if (res.statusCode == 201 && json["success"] == true) {
      // registro OK
      return true;
    } else {
      // puedes lanzar excepción con el mensaje del backend
      throw Exception(json["message"] ?? "Error al registrar usuario");
    }
  }
}
