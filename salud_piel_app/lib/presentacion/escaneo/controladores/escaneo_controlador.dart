import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../nucleo/servicios/ml_servicio.dart';
import '../../rutas/app_rutas.dart';

class EscaneoControlador extends GetxController {
  CameraController? cameraController;
  final inicializando = true.obs;
  final camaraDisponible = false.obs;
  final analizando = false.obs;
  bool _iniciado = false;

  EscaneoControlador();

  Future<void> iniciarCamara() async {
    if (_iniciado) return;
    _iniciado = true;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        camaraDisponible.value = false;
        inicializando.value = false;
        return;
      }
      camaraDisponible.value = true;
      final controller = CameraController(cameras.first, ResolutionPreset.high);
      cameraController = controller;
      await controller.initialize();
      inicializando.value = false;
    } catch (_) {
      camaraDisponible.value = false;
      inicializando.value = false;
    }
  }

  Future<void> tomarFoto() async {
    final cam = cameraController;
    if (cam == null || !cam.value.isInitialized) return;
    try {
      final XFile foto = await cam.takePicture();
      await _analizarYNavigar(foto.path);
    } catch (_) {
      Get.snackbar('Error', 'No se pudo tomar la foto.');
    }
  }

  Future<void> seleccionarDeGaleria() async {
    try {
      final XFile? imagen =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagen != null) {
        await _analizarYNavigar(imagen.path);
      }
    } catch (_) {
      Get.snackbar('Error', 'No se pudo acceder a la galería.');
    }
  }

  Future<void> _analizarYNavigar(String path) async {
    analizando.value = true;
    try {
      final archivo = File(path);
      final resultado = await MlServicio()
          .analizarImagen(archivo)
          .timeout(const Duration(seconds: 45));
      Get.toNamed(AppRutas.diagnostico, arguments: resultado);
    } on TimeoutException {
      Get.snackbar(
        'Tiempo agotado',
        'El análisis tardó demasiado. Prueba con una imagen más clara.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error en análisis',
        'No se pudo analizar la imagen: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      analizando.value = false;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
