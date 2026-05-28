import '../../dominio/entidades/diagnostico.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';
import '../../dominio/enumeraciones/tipo_piel.dart';
import '../../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../datos/app_database.dart';

class DiagnosticoRepositorio implements IDiagnosticoRepositorio {
  final AppDatabase _db;
  DiagnosticoRepositorio(this._db);

  @override
  Future<int> guardar(Diagnostico diagnostico) async {
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

    return id;
  }

  @override
  Future<Diagnostico?> obtenerPorId(int id) async {
    final maps = await _db.db.query(
      'diagnosticos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _mapear(maps.first);
  }

  @override
  Future<List<Diagnostico>> listarTodos() async {
    final maps = await _db.db.query(
      'diagnosticos',
      orderBy: 'fecha DESC',
    );
    return Future.wait(maps.map(_mapear));
  }

  @override
  Future<void> eliminar(int id) async {
    await _db.db.delete('diagnosticos_productos', where: 'diagnostico_id = ?', whereArgs: [id]);
    await _db.db.delete('diagnosticos', where: 'id = ?', whereArgs: [id]);
  }

  Future<Diagnostico> _mapear(Map<String, dynamic> m) async {
    final productos = await _obtenerProductos(m['id'] as int);
    return Diagnostico(
      id: m['id'] as int,
      imagenPath: m['imagen_path'] as String,
      condicion: CondicionPiel.values.firstWhere((c) => c.name == m['condicion']),
      confianza: m['confianza'] as double,
      fecha: DateTime.parse(m['fecha'] as String),
      descripcion: m['descripcion'] as String?,
      productosRecomendados: productos,
    );
  }

  Future<List<Producto>> _obtenerProductos(int diagnosticoId) async {
    final maps = await _db.db.rawQuery('''
      SELECT p.* FROM productos p
      INNER JOIN diagnosticos_productos dp ON dp.producto_id = p.id
      WHERE dp.diagnostico_id = ?
    ''', [diagnosticoId]);
    return maps.map((m) => _mapearProducto(m)).toList();
  }

  Producto _mapearProducto(Map<String, dynamic> m) => Producto(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        descripcion: m['descripcion'] as String?,
        ingredientes: m['ingredientes'] as String?,
        tipoPiel: m['tipo_piel'] != null
            ? TipoPiel.values.firstWhere((t) => t.name == m['tipo_piel'])
            : null,
        condicion: m['condicion'] != null
            ? CondicionPiel.values.firstWhere((c) => c.name == m['condicion'])
            : null,
        imagenPath: m['imagen_path'] as String?,
        comoUsar: m['como_usar'] as String?,
      );
}
