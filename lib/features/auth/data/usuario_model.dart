import '../../auth/domain/usuario.dart';

class UsuarioModel extends Usuario {
  UsuarioModel({
    required super.nombre,
    required super.apellido,
    required super.email,
    required super.telefono,
    required super.password,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      nombre: json["nombre"],
      apellido: json["apellido"],
      email: json["email"],
      telefono: json["telefono"],
      password: json["password"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "telefono": telefono,
        "password": password,
      };
}
