import 'dart:convert';
import 'package:flutter/services.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/enumeraciones/condicion_piel.dart';
import '../../dominio/enumeraciones/tipo_piel.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';
import '../datos/app_database.dart';
import '../modelos/producto_dto.dart';

class ProductoRepositorio implements IProductoRepositorio {
  final AppDatabase _db;
  ProductoRepositorio(this._db);

  @override
  Future<Resultado<List<Producto>>> listar({TipoPiel? tipoPiel, CondicionPiel? condicion}) async {
    try {
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
      return Exito(maps.map(_mapear).toList());
    } catch (e) {
      return Fracaso('Error al listar productos: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Producto>> obtenerPorId(int id) async {
    try {
      final maps = await _db.db.query('productos', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Fracaso('Producto no encontrado');
      return Exito(_mapear(maps.first));
    } catch (e) {
      return Fracaso('Error al obtener producto: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<List<Producto>>> buscar(String query) async {
    try {
      final maps = await _db.db.query(
        'productos',
        where: 'nombre LIKE ? OR descripcion LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return Exito(maps.map(_mapear).toList());
    } catch (e) {
      return Fracaso('Error al buscar productos: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Producto>> buscarPorNombre(String nombre) async {
    try {
      final maps = await _db.db.query(
        'productos',
        where: 'nombre LIKE ?',
        whereArgs: [nombre],
      );
      if (maps.isEmpty) return Fracaso('Producto no encontrado');
      return Exito(_mapear(maps.first));
    } catch (e) {
      return Fracaso('Error al buscar producto: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Producto>> insertar(Producto producto) async {
    try {
      final dto = ProductoDto.fromEntity(producto);
      final map = dto.toMap();
      map.remove('id');
      final id = await _db.db.insert('productos', map);
      return obtenerPorId(id);
    } catch (e) {
      return Fracaso('Error al insertar producto: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Producto>> actualizar(Producto producto) async {
    try {
      final dto = ProductoDto.fromEntity(producto);
      final map = dto.toMap();
      await _db.db.update('productos', map, where: 'id = ?', whereArgs: [producto.id]);
      return Exito(producto);
    } catch (e) {
      return Fracaso('Error al actualizar producto: ${e.toString()}', e is Exception ? e : null);
    }
  }

  Future<void> precargarSemilla() async {
    final count = _db.db.query('productos', limit: 1);
    if ((await count).isNotEmpty) return;

    final json = await rootBundle.loadString('assets/productos/catalogo.json');
    final lista = jsonDecode(json) as List<dynamic>;

    for (final item in lista) {
      await _db.db.insert('productos', {
        'nombre': item['nombre'],
        'marca': item['marca'],
        'categoria': item['categoria'],
        'descripcion': item['descripcion'],
        'ingredientes': item['ingredientes'],
        'tipo_piel': item['tipo_piel'],
        'condicion': item['condicion'],
        'imagen_path': item['imagen_path'],
        'como_usar': item['como_usar'],
      });
    }
  }

  Producto _mapear(Map<String, dynamic> m) =>
      ProductoDto.fromMap(m).toEntity();
}
