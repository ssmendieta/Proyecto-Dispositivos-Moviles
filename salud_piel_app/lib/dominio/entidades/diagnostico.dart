import '../enumeraciones/condicion_piel.dart';
import 'producto.dart';

class Diagnostico {
  final int id;
  final String imagenPath;
  final CondicionPiel condicion;
  final double confianza;
  final DateTime fecha;
  final String? descripcion;
  final List<Producto> productosRecomendados;

  Diagnostico({
    required this.id,
    required this.imagenPath,
    required this.condicion,
    required this.confianza,
    required this.fecha,
    this.descripcion,
    this.productosRecomendados = const [],
  });
}
