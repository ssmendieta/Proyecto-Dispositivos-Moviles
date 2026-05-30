import '../enumeraciones/condicion_piel.dart';
import '../enumeraciones/tipo_piel.dart';

class Producto {
  final int id;
  final String nombre;
  final String? marca;
  final String? categoria;
  final String? descripcion;
  final String? ingredientes;
  final TipoPiel? tipoPiel;
  final CondicionPiel? condicion;
  final String? imagenPath;
  final String? comoUsar;
  final String? instruccionesIA;
  final bool esIA;

  Producto({
    required this.id,
    required this.nombre,
    this.marca,
    this.categoria,
    this.descripcion,
    this.ingredientes,
    this.tipoPiel,
    this.condicion,
    this.imagenPath,
    this.comoUsar,
    this.instruccionesIA,
    this.esIA = false,
  });

  Producto copyWith({
    int? id,
    String? nombre,
    String? marca,
    String? categoria,
    String? descripcion,
    String? ingredientes,
    TipoPiel? tipoPiel,
    CondicionPiel? condicion,
    String? imagenPath,
    String? comoUsar,
    String? instruccionesIA,
    bool? esIA,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      marca: marca ?? this.marca,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      ingredientes: ingredientes ?? this.ingredientes,
      tipoPiel: tipoPiel ?? this.tipoPiel,
      condicion: condicion ?? this.condicion,
      imagenPath: imagenPath ?? this.imagenPath,
      comoUsar: comoUsar ?? this.comoUsar,
      instruccionesIA: instruccionesIA ?? this.instruccionesIA,
      esIA: esIA ?? this.esIA,
    );
  }
}
