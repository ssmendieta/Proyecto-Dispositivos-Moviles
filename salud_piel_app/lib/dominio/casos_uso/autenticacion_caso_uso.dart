import '../entidades/usuario.dart';
import '../repositorios/i_auth_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class AutenticacionCasoUso {
  final IAuthRepositorio _repositorio;

  AutenticacionCasoUso({required IAuthRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<Usuario>> registrar(String username, String email, String password) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return const Fracaso('Todos los campos son obligatorios');
    }
    if (!email.contains('@')) {
      return const Fracaso('Correo electrónico inválido');
    }
    if (password.length < 6) {
      return const Fracaso('La contraseña debe tener al menos 6 caracteres');
    }
    return _repositorio.registrar(username, email, password);
  }

  Future<Resultado<Usuario>> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return const Fracaso('Ingresa tu correo y contraseña');
    }
    if (!email.contains('@')) {
      return const Fracaso('Correo electrónico inválido');
    }
    return _repositorio.login(email, password);
  }

  Future<Resultado<Usuario>> verificarSesion() {
    return _repositorio.obtenerUsuarioActual();
  }
}
