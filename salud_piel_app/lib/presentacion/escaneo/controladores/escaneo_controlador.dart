import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//import '../../../dominio/entidades/resultado_analisis.dart';
import '../../../nucleo/servicios/ml_servicio.dart';

class EscaneoControlador extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final MlServicio _mlServicio = MlServicio();

  bool cargando = false;
  String? mensajeError;
  ResultadoAnalisis? resultado;

  Future<void> seleccionarYAnalizar(ImageSource source) async {
    try {
      cargando = true;
      mensajeError = null;
      resultado = null;
      notifyListeners();

      final XFile? imagen = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 640,
        maxHeight: 640,
        preferredCameraDevice: CameraDevice.front,
      );

      if (imagen == null) {
        cargando = false;
        notifyListeners();
        return;
      }

      debugPrint('Imagen seleccionada: ${imagen.path}');

      final File archivoImagen = File(imagen.path);

      final ResultadoAnalisis resultadoTemporal =
          await _mlServicio.analizarImagen(archivoImagen).timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          throw TimeoutException(
            'El análisis tardó demasiado. Prueba con una imagen más clara o más liviana.',
          );
        },
      );

      resultado = resultadoTemporal;
      cargando = false;
      notifyListeners();
    } catch (e) {
      cargando = false;
      mensajeError = 'Error en el análisis: $e';
      debugPrint(mensajeError);
      notifyListeners();
    }
  }

  Future<void> analizarDesdeGaleria() async {
    await seleccionarYAnalizar(ImageSource.gallery);
  }

  Future<void> analizarDesdeCamara() async {
    await seleccionarYAnalizar(ImageSource.camera);
  }

  void limpiarResultado() {
    resultado = null;
    mensajeError = null;
    cargando = false;
    notifyListeners();
  }
}