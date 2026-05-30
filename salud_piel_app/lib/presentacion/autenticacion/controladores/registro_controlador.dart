import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../../dominio/entidades/usuario.dart';
import '../../../dominio/utilidades/resultado.dart';
import '../../rutas/app_rutas.dart';
import 'sesion_controlador.dart';

class RegistroControlador extends GetxController {
  final AutenticacionCasoUso _casoUso;

  RegistroControlador({required AutenticacionCasoUso casoUso})
      : _casoUso = casoUso;

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
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!correo.contains('@')) {
      Get.snackbar(
        'Correo inválido',
        'Ingresa un correo válido.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Contraseña débil',
        'La contraseña debe tener mínimo 6 caracteres.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Contraseñas diferentes',
        'Las contraseñas no coinciden.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    cargando.value = true;
    final resultado = await _casoUso.registrar(nombre, correo, password);
    cargando.value = false;

    switch (resultado) {
      case Exito<Usuario>():
        Get.find<SesionControlador>().usuarioActual.value = resultado.data;
        Get.find<SesionControlador>().sesionIniciada.value = true;

        Get.offAllNamed(AppRutas.informacionPersonal);

      case Fracaso<Usuario>():
        Get.snackbar(
          'Error',
          resultado.mensaje,
          snackPosition: SnackPosition.TOP,
        );
    }
  }
}