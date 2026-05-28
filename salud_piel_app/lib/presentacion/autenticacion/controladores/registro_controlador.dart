import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sesion_controlador.dart';
import '../../rutas/app_rutas.dart';

class RegistroControlador extends GetxController {
  final SesionControlador _sesionControlador;

  RegistroControlador({required SesionControlador sesionControlador})
      : _sesionControlador = sesionControlador;

  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final verPassword = false.obs;
  final verConfirmPassword = false.obs;
  final cargando = false.obs;

  @override
  void onClose() {
    nombreController.dispose();
    correoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void irALogin() => Get.toNamed(AppRutas.login);

  Future<void> registrar() async {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (nombre.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Campos incompletos',
        'Completa todos los campos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!correo.contains('@')) {
      Get.snackbar(
        'Correo inválido',
        'Ingresa un correo válido.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Contraseña débil',
        'La contraseña debe tener mínimo 6 caracteres.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Contraseñas diferentes',
        'Las contraseñas no coinciden.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    cargando.value = true;
    final exito = await _sesionControlador.registrar(correo, password);
    cargando.value = false;

    if (exito) {
      Get.offAllNamed(AppRutas.inicio);
    } else {
      Get.snackbar(
        'Error',
        'El usuario ya existe o hubo un problema.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
