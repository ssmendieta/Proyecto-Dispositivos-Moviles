import 'dart:io';

import '../../datos/servicios/ml_servicio.dart';

abstract class IMlServicio {
  Future<IMlServicio> init();
  Future<ResultadoAnalisis> analizarImagen(File imagenPath);
  Future<void> cargarModelos();
  void cerrar();
}
