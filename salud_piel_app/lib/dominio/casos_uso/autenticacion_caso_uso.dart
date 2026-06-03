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
    if (username.trim().length < 3) {
      return const Fracaso('El nombre de usuario debe tener al menos 3 caracteres');
    }
    if (email.trim().isEmpty || !email.contains('@') || !email.contains('.')) {
      return const Fracaso('Correo electrónico inválido');
    }
    if (password.trim().length < 6) {
      return const Fracaso('La contraseña debe tener al menos 6 caracteres');
    }
    if (password == username || password == email) {
      return const Fracaso('La contraseña no puede ser igual al usuario o correo');
    }
    return _repositorio.registrar(username, email, password);
  }

  Future<Resultado<Usuario>> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return const Fracaso('Ingresa tu correo y contraseña');
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      return const Fracaso('Correo electrónico inválido');
    }
    return _repositorio.login(email, password);
  }

  Future<Resultado<Usuario>> verificarSesion() {
    return _repositorio.obtenerUsuarioActual();
  }
}
