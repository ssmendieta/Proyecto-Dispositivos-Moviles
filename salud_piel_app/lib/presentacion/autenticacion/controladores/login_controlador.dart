import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sesion_controlador.dart';
import '../../rutas/app_rutas.dart';

class LoginControlador extends GetxController {
  final SesionControlador _sesionControlador;

  LoginControlador({required SesionControlador sesionControlador})
      : _sesionControlador = sesionControlador;

  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final verPassword = false.obs;
  final recordarSesion = false.obs;
  final cargando = false.obs;

  @override
  void onClose() {
    correoController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void irARegistro() => Get.toNamed(AppRutas.registro);

  Future<void> iniciarSesion() async {
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Campos incompletos',
        'Por favor ingresa tu correo y contraseña.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!correo.contains('@')) {
      Get.snackbar(
        'Correo inválido',
        'Ingresa un correo electrónico válido.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    cargando.value = true;
    final exito = await _sesionControlador.login(correo, password);
    cargando.value = false;

    if (exito) {
      Get.offAllNamed(AppRutas.inicio);
    } else {
      Get.snackbar(
        'Error',
        'Credenciales incorrectas.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
