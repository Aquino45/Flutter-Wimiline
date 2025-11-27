import 'usuario.dart';

abstract class AuthRepository {
  Future<bool> register(Usuario usuario);
}
