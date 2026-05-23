import '../enumeraciones/momento_rutina.dart';
import 'producto.dart';

class Rutina {
  final int id;
  final String nombre;
  final MomentoRutina momento;
  final DateTime fechaCreacion;
  final List<RutinaProducto> productos;

  Rutina({
    required this.id,
    required this.nombre,
    required this.momento,
    required this.fechaCreacion,
    this.productos = const [],
  });
}

class RutinaProducto {
  final Producto producto;
  final int orden;
  final bool completado;

  RutinaProducto({
    required this.producto,
    this.orden = 0,
    this.completado = false,
  });
}
