import '../../dominio/entidades/rutina.dart';
import '../../dominio/enumeraciones/momento_rutina.dart';

class RutinaDto {
  final int id;
  final String nombre;
  final String momento;
  final String fechaCreacion;

  const RutinaDto({
    required this.id,
    required this.nombre,
    required this.momento,
    required this.fechaCreacion,
  });

  factory RutinaDto.fromMap(Map<String, dynamic> m) => RutinaDto(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        momento: m['momento'] as String,
        fechaCreacion: m['fecha_creacion'] as String,
      );

  factory RutinaDto.fromEntity(Rutina e) => RutinaDto(
        id: e.id,
        nombre: e.nombre,
        momento: e.momento.name,
        fechaCreacion: e.fechaCreacion.toIso8601String(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'momento': momento,
        'fecha_creacion': fechaCreacion,
      };

  Rutina toEntity({List<RutinaProducto> productos = const []}) => Rutina(
        id: id,
        nombre: nombre,
        momento: MomentoRutina.values.firstWhere((mr) => mr.name == momento),
        fechaCreacion: DateTime.parse(fechaCreacion),
        productos: productos,
      );
}
