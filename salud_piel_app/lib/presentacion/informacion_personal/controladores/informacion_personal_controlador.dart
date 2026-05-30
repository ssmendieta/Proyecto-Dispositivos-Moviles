import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../rutas/app_rutas.dart';

class InformacionPersonalControlador extends GetxController {
  final edadController = TextEditingController();
  final horaDormirController = TextEditingController();
  final alergiasController = TextEditingController();

  final tipoPiel = 'Grasa'.obs;

  final tiposPiel = [
    'Grasa',
    'Seca',
    'Mixta',
    'Sensible',
    'Normal',
  ];

  void cambiarTipoPiel(String valor) {
    tipoPiel.value = valor;
  }

  void continuar() {
    final edad = edadController.text.trim();
    final horaDormir = horaDormirController.text.trim();

    if (edad.isEmpty || horaDormir.isEmpty) {
      Get.snackbar(
        'Campos incompletos',
        'Ingresa tu edad y hora aproximada de dormir.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.offAllNamed(AppRutas.inicio);
  }

  @override
  void onClose() {
    edadController.dispose();
    horaDormirController.dispose();
    alergiasController.dispose();
    super.onClose();
  }
}