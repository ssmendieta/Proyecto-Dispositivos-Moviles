import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../../dominio/entidades/usuario.dart';
import '../../../dominio/utilidades/resultado.dart';
import '../../rutas/app_rutas.dart';
import 'sesion_controlador.dart';

class LoginControlador extends GetxController {
  final AutenticacionCasoUso _casoUso;

  LoginControlador({required AutenticacionCasoUso casoUso})
      : _casoUso = casoUso;

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
        'Ingresa tu correo y contraseña.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!correo.contains('@')) {
      Get.snackbar(
        'Correo inválido',
        'Ingresa un correo electrónico válido.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    cargando.value = true;
    final resultado = await _casoUso.login(correo, password);
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