import '../../dominio/utilidades/resultado.dart';
import '../entidades/usuario.dart';

abstract class IAuthRepositorio {
  Future<Resultado<Usuario>> registrar(String username, String email, String password);
  Future<Resultado<Usuario>> login(String email, String password);
  Future<Resultado<Usuario>> obtenerUsuarioActual();
}
