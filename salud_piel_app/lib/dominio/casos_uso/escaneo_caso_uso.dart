import 'dart:io';

import '../../datos/servicios/ml_servicio.dart';
import '../repositorios/i_ml_servicio.dart';
import '../../dominio/utilidades/resultado.dart';

class EscaneoCasoUso {
  final IMlServicio _mlServicio;

  EscaneoCasoUso({required IMlServicio mlServicio})
      : _mlServicio = mlServicio;

  Future<Resultado<ResultadoAnalisis>> analizar(File imagen) async {
    if (!await imagen.exists()) {
      return const Fracaso('El archivo de imagen no existe');
    }

    final tamano = await imagen.length();
    if (tamano == 0) {
      return const Fracaso('El archivo de imagen esta vacio');
    }
    if (tamano > 20 * 1024 * 1024) {
      return const Fracaso('La imagen es demasiado grande (maximo 20MB)');
    }

    final extension = imagen.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
      return const Fracaso('Formato no soportado. Use JPG, PNG o WebP');
    }

    try {
      final resultado = await _mlServicio.analizarImagen(imagen);
      return Exito(resultado);
    } catch (e) {
      return Fracaso('No se pudo analizar la imagen: ${e.toString()}');
    }
  }
}
