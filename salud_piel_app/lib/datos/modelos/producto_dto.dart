import '../../dominio/entidades/producto.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';
import '../../dominio/enumeraciones/tipo_piel.dart';

class ProductoDto {
  final int id;
  final String nombre;
  final String? marca;
  final String? categoria;
  final String? compatibilidad;
  final String? descripcion;
  final String? ingredientes;
  final String? tipoPiel;
  final String? condicion;
  final String? imagenPath;
  final String? comoUsar;

  const ProductoDto({
    required this.id,
    required this.nombre,
    this.marca,
    this.categoria,
    this.compatibilidad,
    this.descripcion,
    this.ingredientes,
    this.tipoPiel,
    this.condicion,
    this.imagenPath,
    this.comoUsar,
  });

  factory ProductoDto.fromMap(Map<String, dynamic> m) => ProductoDto(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        marca: m['marca'] as String?,
        categoria: m['categoria'] as String?,
        compatibilidad: m['compatibilidad'] as String?,
        descripcion: m['descripcion'] as String?,
        ingredientes: m['ingredientes'] as String?,
        tipoPiel: m['tipo_piel'] as String?,
        condicion: m['condicion'] as String?,
        imagenPath: m['imagen_path'] as String?,
        comoUsar: m['como_usar'] as String?,
      );

  factory ProductoDto.fromEntity(Producto e) => ProductoDto(
        id: e.id,
        nombre: e.nombre,
        marca: e.marca,
        categoria: e.categoria,
        compatibilidad: e.compatibilidad,
        descripcion: e.descripcion,
        ingredientes: e.ingredientes,
        tipoPiel: e.tipoPiel?.name,
        condicion: e.condicion?.name,
        imagenPath: e.imagenPath,
        comoUsar: e.comoUsar,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'marca': marca,
        'categoria': categoria,
        'compatibilidad': compatibilidad,
        'descripcion': descripcion,
        'ingredientes': ingredientes,
        'tipo_piel': tipoPiel,
        'condicion': condicion,
        'imagen_path': imagenPath,
        'como_usar': comoUsar,
      };

  Producto toEntity() => Producto(
        id: id,
        nombre: nombre,
        marca: marca,
        categoria: categoria,
        compatibilidad: compatibilidad,
        descripcion: descripcion,
        ingredientes: ingredientes,
        tipoPiel: tipoPiel != null
            ? TipoPiel.values.firstWhere((t) => t.name == tipoPiel)
            : null,
        condicion: condicion != null
            ? CondicionPiel.values.firstWhere((c) => c.name == condicion)
            : null,
        imagenPath: imagenPath,
        comoUsar: comoUsar,
      );
}
