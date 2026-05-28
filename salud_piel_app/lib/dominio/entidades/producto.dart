import '../enumeraciones/condicion_piel.dart';
import '../enumeraciones/tipo_piel.dart';

class Producto {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? ingredientes;
  final TipoPiel? tipoPiel;
  final CondicionPiel? condicion;
  final String? imagenPath;
  final String? comoUsar;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.ingredientes,
    this.tipoPiel,
    this.condicion,
    this.imagenPath,
    this.comoUsar,
  });
}
