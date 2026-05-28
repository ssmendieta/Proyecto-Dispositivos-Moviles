import 'dart:async';

import 'package:get/get.dart';

import '../../autenticacion/controladores/sesion_controlador.dart';
import '../../rutas/app_rutas.dart';

class CargaControlador extends GetxController {
  final SesionControlador _sesionControlador;

  CargaControlador({required SesionControlador sesionControlador})
      : _sesionControlador = sesionControlador;

  @override
  void onInit() {
    super.onInit();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await Future.delayed(const Duration(seconds: 2));
    await _sesionControlador.verificarSesion();

    if (_sesionControlador.sesionIniciada.value) {
      Get.offNamed(AppRutas.inicio);
    } else {
      Get.offNamed(AppRutas.bienvenida);
    }
  }
}
