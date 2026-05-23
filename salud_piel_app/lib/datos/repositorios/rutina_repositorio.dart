import '../../dominio/entidades/producto.dart';
import '../../dominio/entidades/rutina.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';
import '../../dominio/enumeraciones/momento_rutina.dart';
import '../../dominio/enumeraciones/tipo_piel.dart';
import '../../dominio/repositorios/i_rutina_repositorio.dart';
import '../datos/app_database.dart';

class RutinaRepositorio implements IRutinaRepositorio {
  final AppDatabase _db;
  RutinaRepositorio(this._db);

  @override
  Future<int> crear(String nombre, MomentoRutina momento) async {
    return await _db.db.insert('rutinas', {
      'nombre': nombre,
      'momento': momento.name,
      'fecha_creacion': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<Rutina?> obtener(int id) async {
    final maps = await _db.db.query('rutinas', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _mapear(maps.first);
  }

  @override
  Future<List<Rutina>> listar() async {
    final maps = await _db.db.query('rutinas', orderBy: 'fecha_creacion DESC');
    return Future.wait(maps.map(_mapear));
  }

  @override
  Future<void> actualizar(Rutina rutina) async {
    await _db.db.update(
      'rutinas',
      {'nombre': rutina.nombre, 'momento': rutina.momento.name},
      where: 'id = ?',
      whereArgs: [rutina.id],
    );
  }

  @override
  Future<void> eliminar(int id) async {
    await _db.db.delete('rutinas_productos', where: 'rutina_id = ?', whereArgs: [id]);
    await _db.db.delete('rutinas', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> agregarProducto(int rutinaId, int productoId, int orden) async {
    await _db.db.insert('rutinas_productos', {
      'rutina_id': rutinaId,
      'producto_id': productoId,
      'orden': orden,
      'completado': 0,
    });
  }

  @override
  Future<void> quitarProducto(int rutinaId, int productoId) async {
    await _db.db.delete(
      'rutinas_productos',
      where: 'rutina_id = ? AND producto_id = ?',
      whereArgs: [rutinaId, productoId],
    );
  }

  @override
  Future<void> marcarCompletado(int rutinaId, int productoId, bool completado) async {
    await _db.db.update(
      'rutinas_productos',
      {'completado': completado ? 1 : 0},
      where: 'rutina_id = ? AND producto_id = ?',
      whereArgs: [rutinaId, productoId],
    );
  }

  Future<Rutina> _mapear(Map<String, dynamic> m) async {
    final productos = await _obtenerProductos(m['id'] as int);
    return Rutina(
      id: m['id'] as int,
      nombre: m['nombre'] as String,
      momento: MomentoRutina.values.firstWhere((mr) => mr.name == m['momento']),
      fechaCreacion: DateTime.parse(m['fecha_creacion'] as String),
      productos: productos,
    );
  }

  Future<List<RutinaProducto>> _obtenerProductos(int rutinaId) async {
    final maps = await _db.db.rawQuery('''
      SELECT p.*, rp.orden, rp.completado
      FROM productos p
      INNER JOIN rutinas_productos rp ON rp.producto_id = p.id
      WHERE rp.rutina_id = ?
      ORDER BY rp.orden ASC
    ''', [rutinaId]);

    return maps.map((m) => RutinaProducto(
          producto: Producto(
            id: m['id'] as int,
            nombre: m['nombre'] as String,
            descripcion: m['descripcion'] as String?,
            ingredientes: m['ingredientes'] as String?,
            tipoPiel: (m['tipo_piel'] as String?) != null
                ? TipoPiel.values.firstWhere((t) => t.name == m['tipo_piel'])
                : null,
            condicion: (m['condicion'] as String?) != null
                ? CondicionPiel.values.firstWhere((c) => c.name == m['condicion'])
                : null,
            imagenPath: m['imagen_path'] as String?,
            comoUsar: m['como_usar'] as String?,
          ),
          orden: m['orden'] as int,
          completado: (m['completado'] as int) == 1,
        )).toList();
  }
}
