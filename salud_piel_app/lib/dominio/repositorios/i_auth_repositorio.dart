import '../../nucleo/utilidades/resultado.dart';
import '../entidades/usuario.dart';

abstract class IAuthRepositorio {
  Future<Resultado<Usuario>> registrar(String username, String password);
  Future<Resultado<Usuario>> login(String username, String password);
  Future<Resultado<Usuario>> obtenerUsuarioActual();
}
