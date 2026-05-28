import '../../dominio/entidades/rutina.dart';
import '../../dominio/enumeraciones/momento_rutina.dart';
import '../../dominio/repositorios/i_rutina_repositorio.dart';
import '../../nucleo/utilidades/resultado.dart';
import '../datos/app_database.dart';
import '../modelos/producto_dto.dart';
import '../modelos/rutina_dto.dart';

class RutinaRepositorio implements IRutinaRepositorio {
  final AppDatabase _db;
  RutinaRepositorio(this._db);

  @override
  Future<Resultado<int>> crear(String nombre, MomentoRutina momento) async {
    try {
      final id = await _db.db.insert('rutinas', {
        'nombre': nombre,
        'momento': momento.name,
        'fecha_creacion': DateTime.now().toIso8601String(),
      });
      return Exito(id);
    } catch (e) {
      return Fracaso('Error al crear rutina: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Rutina>> obtener(int id) async {
    final maps = await _db.db.query('rutinas', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return Fracaso('Rutina no encontrada');
    return Exito(await _mapear(maps.first));
  }

  @override
  Future<Resultado<List<Rutina>>> listar() async {
    try {
      final maps = await _db.db.query('rutinas', orderBy: 'fecha_creacion DESC');
      return Exito(await Future.wait(maps.map(_mapear)));
    } catch (e) {
      return Fracaso('Error al listar rutinas: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Null>> actualizar(Rutina rutina) async {
    try {
      await _db.db.update(
        'rutinas',
        {'nombre': rutina.nombre, 'momento': rutina.momento.name},
        where: 'id = ?',
        whereArgs: [rutina.id],
      );
      return const Exito(null);
    } catch (e) {
      return Fracaso('Error al actualizar rutina: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Null>> eliminar(int id) async {
    try {
      await _db.db.delete('rutinas_productos', where: 'rutina_id = ?', whereArgs: [id]);
      await _db.db.delete('rutinas', where: 'id = ?', whereArgs: [id]);
      return const Exito(null);
    } catch (e) {
      return Fracaso('Error al eliminar rutina: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Null>> agregarProducto(int rutinaId, int productoId, int orden) async {
    try {
      await _db.db.insert('rutinas_productos', {
        'rutina_id': rutinaId,
        'producto_id': productoId,
        'orden': orden,
        'completado': 0,
      });
      return const Exito(null);
    } catch (e) {
      return Fracaso('Error al agregar producto: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Null>> quitarProducto(int rutinaId, int productoId) async {
    try {
      await _db.db.delete(
        'rutinas_productos',
        where: 'rutina_id = ? AND producto_id = ?',
        whereArgs: [rutinaId, productoId],
      );
      return const Exito(null);
    } catch (e) {
      return Fracaso('Error al quitar producto: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Null>> marcarCompletado(int rutinaId, int productoId, bool completado) async {
    try {
      await _db.db.update(
        'rutinas_productos',
        {'completado': completado ? 1 : 0},
        where: 'rutina_id = ? AND producto_id = ?',
        whereArgs: [rutinaId, productoId],
      );
      return const Exito(null);
    } catch (e) {
      return Fracaso('Error al marcar completado: ${e.toString()}', e is Exception ? e : null);
    }
  }

  Future<Rutina> _mapear(Map<String, dynamic> m) async {
    final productos = await _obtenerProductos(m['id'] as int);
    return RutinaDto.fromMap(m).toEntity(productos: productos);
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
          producto: ProductoDto.fromMap(m).toEntity(),
          orden: m['orden'] as int,
          completado: (m['completado'] as int) == 1,
        )).toList();
  }
}
