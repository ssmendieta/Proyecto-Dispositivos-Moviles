import 'package:get/get.dart';

import '../../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../../dominio/entidades/usuario.dart';
import '../../../nucleo/utilidades/resultado.dart';
import '../../rutas/app_rutas.dart';

class SesionControlador extends GetxController {
  final AutenticacionCasoUso _casoUso;

  SesionControlador({required AutenticacionCasoUso casoUso})
      : _casoUso = casoUso;

  final usuarioActual = Rx<Usuario?>(null);
  final sesionIniciada = false.obs;
  final cargando = false.obs;

  String get nombreUsuario =>
      usuarioActual.value?.username ?? 'Usuario';

  Future<bool> registrar(String username, String email, String password) async {
    cargando.value = true;
    final resultado = await _casoUso.registrar(username, email, password);
    switch (resultado) {
      case Exito<Usuario>():
        usuarioActual.value = resultado.data;
        sesionIniciada.value = true;
        cargando.value = false;
        return true;
      case Fracaso<Usuario>():
        cargando.value = false;
        return false;
    }
  }

  Future<bool> login(String email, String password) async {
    cargando.value = true;
    final resultado = await _casoUso.login(email, password);
    switch (resultado) {
      case Exito<Usuario>():
        usuarioActual.value = resultado.data;
        sesionIniciada.value = true;
        cargando.value = false;
        return true;
      case Fracaso<Usuario>():
        cargando.value = false;
        return false;
    }
  }

  void cerrarSesion() {
    usuarioActual.value = null;
    sesionIniciada.value = false;
    Get.offAllNamed(AppRutas.login);
  }

  Future<void> verificarSesion() async {
    final resultado = await _casoUso.verificarSesion();
    switch (resultado) {
      case Exito<Usuario>():
        usuarioActual.value = resultado.data;
        sesionIniciada.value = true;
      case Fracaso<Usuario>():
        usuarioActual.value = null;
        sesionIniciada.value = false;
    }
  }
}
