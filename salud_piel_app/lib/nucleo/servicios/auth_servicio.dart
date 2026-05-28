import 'package:get/get.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';

class AuthServicio extends GetxService {
  final _repositorio = Get.find<IAuthRepositorio>();
  final usuarioActual = Rx<Usuario?>(null);
  final sesionIniciada = false.obs;
  final cargando = false.obs;

  Future<bool> registrar(String username, String password) async {
    cargando.value = true;
    final usuario = await _repositorio.registrar(username, password);
    if (usuario != null) {
      usuarioActual.value = usuario;
      sesionIniciada.value = true;
    }
    cargando.value = false;
    return usuario != null;
  }

  Future<bool> login(String username, String password) async {
    cargando.value = true;
    final usuario = await _repositorio.login(username, password);
    if (usuario != null) {
      usuarioActual.value = usuario;
      sesionIniciada.value = true;
    }
    cargando.value = false;
    return usuario != null;
  }

  void cerrarSesion() {
    usuarioActual.value = null;
    sesionIniciada.value = false;
  }

  Future<void> verificarSesion() async {
    final usuario = await _repositorio.obtenerUsuarioActual();
    usuarioActual.value = usuario;
    sesionIniciada.value = usuario != null;
  }
}
