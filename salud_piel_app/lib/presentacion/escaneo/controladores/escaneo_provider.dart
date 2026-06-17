import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../datos/providers/dependencias_provider.dart';
import '../../../datos/servicios/ml_servicio.dart';
import '../../../dominio/casos_uso/escaneo_caso_uso.dart';
import '../../../dominio/utilidades/resultado.dart';

class EscaneoEstado {
  final bool inicializando;
  final bool camaraDisponible;
  final bool analizando;
  final String? error;

  const EscaneoEstado({
    required this.inicializando,
    required this.camaraDisponible,
    required this.analizando,
    this.error,
  });

  EscaneoEstado copyWith({
    bool? inicializando,
    bool? camaraDisponible,
    bool? analizando,
    String? error,
    bool limpiarError = false,
  }) {
    return EscaneoEstado(
      inicializando: inicializando ?? this.inicializando,
      camaraDisponible: camaraDisponible ?? this.camaraDisponible,
      analizando: analizando ?? this.analizando,
      error: limpiarError ? null : error ?? this.error,
    );
  }
}

class EscaneoNotifier extends StateNotifier<EscaneoEstado> {
  final EscaneoCasoUso _casoUso;

  CameraController? cameraController;
  bool _iniciado = false;

  EscaneoNotifier({
    required EscaneoCasoUso casoUso,
  })  : _casoUso = casoUso,
        super(
          const EscaneoEstado(
            inicializando: true,
            camaraDisponible: false,
            analizando: false,
          ),
        );

  Future<void> iniciarCamara() async {
    if (_iniciado) {
      return;
    }

    _iniciado = true;

    state = state.copyWith(
      inicializando: true,
      limpiarError: true,
    );

    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        state = state.copyWith(
          camaraDisponible: false,
          inicializando: false,
        );
        return;
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      cameraController = controller;

      await controller.initialize();

      state = state.copyWith(
        camaraDisponible: true,
        inicializando: false,
        limpiarError: true,
      );
    } catch (_) {
      state = state.copyWith(
        camaraDisponible: false,
        inicializando: false,
        error: 'No se pudo iniciar la cámara.',
      );
    }
  }

  Future<ResultadoAnalisis?> tomarFoto() async {
    final cam = cameraController;

    if (cam == null || !cam.value.isInitialized) {
      state = state.copyWith(
        error: 'La cámara no está lista.',
      );
      return null;
    }

    try {
      final foto = await cam.takePicture();
      return _analizarImagen(foto.path);
    } catch (_) {
      state = state.copyWith(
        error: 'No se pudo tomar la foto.',
      );
      return null;
    }
  }

  Future<ResultadoAnalisis?> seleccionarDeGaleria() async {
    try {
      final imagen = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (imagen == null) {
        return null;
      }

      return _analizarImagen(imagen.path);
    } catch (_) {
      state = state.copyWith(
        error: 'No se pudo acceder a la galería.',
      );
      return null;
    }
  }

  Future<ResultadoAnalisis?> _analizarImagen(String path) async {
    state = state.copyWith(
      analizando: true,
      limpiarError: true,
    );

    try {
      final archivo = File(path);

      final resultado = await _casoUso
          .analizar(archivo)
          .timeout(const Duration(seconds: 45));

      switch (resultado) {
        case Exito<ResultadoAnalisis>():
          state = state.copyWith(
            analizando: false,
            limpiarError: true,
          );
          return resultado.data;

        case Fracaso<ResultadoAnalisis>():
          state = state.copyWith(
            analizando: false,
            error: resultado.mensaje,
          );
          return null;
      }
    } on TimeoutException {
      state = state.copyWith(
        analizando: false,
        error:
            'El análisis tardó demasiado. Prueba con una imagen más clara.',
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        analizando: false,
        error: 'No se pudo analizar la imagen.',
      );
      return null;
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    cameraController = null;
    super.dispose();
  }
}

final escaneoProvider =
    StateNotifierProvider.autoDispose<EscaneoNotifier, EscaneoEstado>(
  (ref) {
    return EscaneoNotifier(
      casoUso: ref.watch(escaneoCasoUsoProvider),
    );
  },
);