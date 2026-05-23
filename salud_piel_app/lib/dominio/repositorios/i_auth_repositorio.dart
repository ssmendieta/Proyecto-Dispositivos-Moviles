import '../entidades/usuario.dart';

abstract class IAuthRepositorio {
  Future<Usuario?> registrar(String username, String password);
  Future<Usuario?> login(String username, String password);
  Future<Usuario?> obtenerUsuarioActual();
}
