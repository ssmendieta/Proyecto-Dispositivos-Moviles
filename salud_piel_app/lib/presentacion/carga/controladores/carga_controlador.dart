import 'dart:async';

import 'package:get/get.dart';

import '../../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../../dominio/entidades/usuario.dart';
import '../../../dominio/utilidades/resultado.dart';
import '../../autenticacion/controladores/sesion_controlador.dart';
import '../../rutas/app_rutas.dart';

class CargaControlador extends GetxController {
  final AutenticacionCasoUso _casoUso;

  CargaControlador({required AutenticacionCasoUso casoUso})
      : _casoUso = casoUso;

  @override
  void onInit() {
    super.onInit();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await Future.delayed(const Duration(seconds: 2));
    final resultado = await _casoUso.verificarSesion();

    switch (resultado) {
      case Exito<Usuario>():
        Get.find<SesionControlador>().usuarioActual.value = resultado.data;
        Get.find<SesionControlador>().sesionIniciada.value = true;
        Get.offNamed(AppRutas.inicio);
      case Fracaso<Usuario>():
        Get.offNamed(AppRutas.bienvenida);
    }
  }
}
