import '../../dominio/entidades/diagnostico.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';

class DiagnosticoDto {
  final int id;
  final String imagenPath;
  final String condicion;
  final double confianza;
  final String fecha;
  final String? descripcion;

  const DiagnosticoDto({
    required this.id,
    required this.imagenPath,
    required this.condicion,
    required this.confianza,
    required this.fecha,
    this.descripcion,
  });

  factory DiagnosticoDto.fromMap(Map<String, dynamic> m) => DiagnosticoDto(
        id: m['id'] as int,
        imagenPath: m['imagen_path'] as String,
        condicion: m['condicion'] as String,
        confianza: m['confianza'] as double,
        fecha: m['fecha'] as String,
        descripcion: m['descripcion'] as String?,
      );

  factory DiagnosticoDto.fromEntity(Diagnostico e) => DiagnosticoDto(
        id: e.id,
        imagenPath: e.imagenPath,
        condicion: e.condicion.name,
        confianza: e.confianza,
        fecha: e.fecha.toIso8601String(),
        descripcion: e.descripcion,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'imagen_path': imagenPath,
        'condicion': condicion,
        'confianza': confianza,
        'fecha': fecha,
        'descripcion': descripcion,
      };

  Diagnostico toEntity({List<Producto> productosRecomendados = const []}) =>
      Diagnostico(
        id: id,
        imagenPath: imagenPath,
        condicion:
            CondicionPiel.values.firstWhere((c) => c.name == condicion),
        confianza: confianza,
        fecha: DateTime.parse(fecha),
        descripcion: descripcion,
        productosRecomendados: productosRecomendados,
      );
}
