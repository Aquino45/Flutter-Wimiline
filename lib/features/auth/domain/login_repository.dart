import 'usuario_login.dart';

abstract class LoginRepository {
  Future<String> login(UsuarioLogin user);
}
