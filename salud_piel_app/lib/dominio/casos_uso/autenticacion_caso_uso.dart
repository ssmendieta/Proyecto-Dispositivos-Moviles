import '../entidades/usuario.dart';
import '../repositorios/i_auth_repositorio.dart';
import '../../nucleo/utilidades/resultado.dart';

class AutenticacionCasoUso {
  final IAuthRepositorio _repositorio;

  AutenticacionCasoUso({required IAuthRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<Usuario>> registrar(String username, String password) {
    return _repositorio.registrar(username, password);
  }

  Future<Resultado<Usuario>> login(String username, String password) {
    return _repositorio.login(username, password);
  }

  Future<Resultado<Usuario>> verificarSesion() {
    return _repositorio.obtenerUsuarioActual();
  }
}
