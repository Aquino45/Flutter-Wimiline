import '../../auth/domain/usuario_login.dart';

class UsuarioLoginModel extends UsuarioLogin {
  UsuarioLoginModel({
    required super.email,
    required super.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };

  factory UsuarioLoginModel.fromJson(Map<String, dynamic> json) {
    return UsuarioLoginModel(
      email: json["email"],
      password: json["password"],
    );
  }
}
