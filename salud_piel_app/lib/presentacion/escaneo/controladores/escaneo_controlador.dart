import 'package:camera/camera.dart';

import '../../../dominio/casos_uso/escaneo_caso_uso.dart';

class EscaneoControlador {
  final EscaneoCasoUso casoUso;

  CameraController? cameraController;

  EscaneoControlador({
    required this.casoUso,
  });

  Future<void> iniciarCamara() async {}

  Future<void> tomarFoto() async {}

  Future<void> seleccionarDeGaleria() async {}

  void cerrar() {
    cameraController?.dispose();
  }
}