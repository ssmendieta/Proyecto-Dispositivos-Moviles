import 'dart:convert';
import 'package:flutter/services.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';
import '../../dominio/enumeraciones/tipo_piel.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../datos/app_database.dart';

class ProductoRepositorio implements IProductoRepositorio {
  final AppDatabase _db;
  ProductoRepositorio(this._db);

  @override
  Future<List<Producto>> listar({TipoPiel? tipoPiel, CondicionPiel? condicion}) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (tipoPiel != null) {
      conditions.add('(tipo_piel = ? OR tipo_piel IS NULL)');
      args.add(tipoPiel.name);
    }
    if (condicion != null) {
      conditions.add('(condicion = ? OR condicion IS NULL)');
      args.add(condicion.name);
    }

    final where = conditions.isEmpty ? null : conditions.join(' AND ');
    final maps = await _db.db.query('productos', where: where, whereArgs: args.isNotEmpty ? args : null);
    return maps.map(_mapear).toList();
  }

  @override
  Future<Producto?> obtenerPorId(int id) async {
    final maps = await _db.db.query('productos', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _mapear(maps.first);
  }

  @override
  Future<List<Producto>> buscar(String query) async {
    final maps = await _db.db.query(
      'productos',
      where: 'nombre LIKE ? OR descripcion LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map(_mapear).toList();
  }

  Future<void> precargarSemilla() async {
    final count = _db.db.query('productos', limit: 1);
    if ((await count).isNotEmpty) return;

    final json = await rootBundle.loadString('assets/productos/catalogo.json');
    final lista = jsonDecode(json) as List<dynamic>;

    for (final item in lista) {
      await _db.db.insert('productos', {
        'nombre': item['nombre'],
        'descripcion': item['descripcion'],
        'ingredientes': item['ingredientes'],
        'tipo_piel': item['tipo_piel'],
        'condicion': item['condicion'],
        'imagen_path': item['imagen_path'],
        'como_usar': item['como_usar'],
      });
    }
  }

  Producto _mapear(Map<String, dynamic> m) => Producto(
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
