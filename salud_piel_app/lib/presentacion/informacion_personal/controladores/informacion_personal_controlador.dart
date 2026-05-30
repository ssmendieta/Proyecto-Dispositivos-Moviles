import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void onInit() {
    super.onInit();
    _cargarDatosGuardados();
  }

  Future<void> _cargarDatosGuardados() async {
    final prefs = await SharedPreferences.getInstance();
    final edad = prefs.getString('info_edad') ?? '';
    final hora = prefs.getString('info_hora_dormir') ?? '';
    final alergias = prefs.getString('info_alergias') ?? '';
    final piel = prefs.getString('info_tipo_piel') ?? '';

    if (edad.isNotEmpty) edadController.text = edad;
    if (hora.isNotEmpty) horaDormirController.text = hora;
    if (alergias.isNotEmpty) alergiasController.text = alergias;
    if (piel.isNotEmpty) tipoPiel.value = piel;
  }

  void cambiarTipoPiel(String valor) {
    tipoPiel.value = valor;
  }

  Future<void> continuar() async {
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('info_edad', edad);
    await prefs.setString('info_hora_dormir', horaDormir);
    await prefs.setString('info_alergias', alergiasController.text.trim());
    await prefs.setString('info_tipo_piel', tipoPiel.value);

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