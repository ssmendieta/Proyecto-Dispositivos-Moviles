import '../../dominio/entidades/diagnostico.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';
import '../datos/app_database.dart';
import '../modelos/diagnostico_dto.dart';
import '../modelos/producto_dto.dart';

class DiagnosticoRepositorio implements IDiagnosticoRepositorio {
  final AppDatabase _db;
  DiagnosticoRepositorio(this._db);

  @override
  Future<Resultado<int>> guardar(Diagnostico diagnostico) async {
    try {
      final id = await _db.db.insert('diagnosticos', {
        'imagen_path': diagnostico.imagenPath,
        'condicion': diagnostico.condicion.name,
        'confianza': diagnostico.confianza,
        'fecha': diagnostico.fecha.toIso8601String(),
        'descripcion': diagnostico.descripcion,
      });

      for (final p in diagnostico.productosRecomendados) {
        await _db.db.insert('diagnosticos_productos', {
          'diagnostico_id': id,
          'producto_id': p.id,
        });
      }

      return Exito(id);
    } catch (e) {
      return Fracaso('Error al guardar diagnóstico: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Diagnostico>> obtenerPorId(int id) async {
    final maps = await _db.db.query(
      'diagnosticos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return Fracaso('Diagnóstico no encontrado');
    return Exito(await _mapear(maps.first));
  }

  @override
  Future<Resultado<List<Diagnostico>>> listarTodos() async {
    try {
      final maps = await _db.db.query(
        'diagnosticos',
        orderBy: 'fecha DESC',
      );
      final lista = await Future.wait(maps.map(_mapear));
      return Exito(lista);
    } catch (e) {
      return Fracaso('Error al listar diagnósticos: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Null>> eliminar(int id) async {
    try {
      await _db.db.delete('diagnosticos_productos', where: 'diagnostico_id = ?', whereArgs: [id]);
      await _db.db.delete('diagnosticos', where: 'id = ?', whereArgs: [id]);
      return const Exito(null);
    } catch (e) {
      return Fracaso('Error al eliminar diagnóstico: ${e.toString()}', e is Exception ? e : null);
    }
  }

  Future<Diagnostico> _mapear(Map<String, dynamic> m) async {
    final productos = await _obtenerProductos(m['id'] as int);
    return DiagnosticoDto.fromMap(m).toEntity(productosRecomendados: productos);
  }

  Future<List<Producto>> _obtenerProductos(int diagnosticoId) async {
    final maps = await _db.db.rawQuery('''
      SELECT p.* FROM productos p
      INNER JOIN diagnosticos_productos dp ON dp.producto_id = p.id
      WHERE dp.diagnostico_id = ?
    ''', [diagnosticoId]);
    return maps.map((m) => _mapearProducto(m)).toList();
  }

  Producto _mapearProducto(Map<String, dynamic> m) =>
      ProductoDto.fromMap(m).toEntity();
}
