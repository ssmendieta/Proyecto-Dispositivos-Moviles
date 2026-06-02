import 'dart:io';

import '../../datos/servicios/ml_servicio.dart';
import '../repositorios/i_ml_servicio.dart';

class EscaneoCasoUso {
  final IMlServicio _mlServicio;

  EscaneoCasoUso({required IMlServicio mlServicio})
      : _mlServicio = mlServicio;

  Future<ResultadoAnalisis> analizar(File imagen) {
    return _mlServicio.analizarImagen(imagen);
  }
}
