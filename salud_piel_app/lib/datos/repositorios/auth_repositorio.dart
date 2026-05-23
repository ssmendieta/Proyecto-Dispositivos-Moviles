import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../datos/app_database.dart';

class AuthRepositorio implements IAuthRepositorio {
  final AppDatabase _db;
  AuthRepositorio(this._db);

  @override
  Future<Usuario?> registrar(String username, String password) async {
    final hash = sha256.convert(utf8.encode(password)).toString();
    final now = DateTime.now().toIso8601String();
    try {
      final id = await _db.db.insert('usuarios', {
        'username': username,
        'password_hash': hash,
        'fecha_creacion': now,
      });
      return Usuario(
        id: id,
        username: username,
        passwordHash: hash,
        fechaCreacion: DateTime.parse(now),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Usuario?> login(String username, String password) async {
    final hash = sha256.convert(utf8.encode(password)).toString();
    final maps = await _db.db.query(
      'usuarios',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, hash],
    );
    if (maps.isEmpty) return null;
    return _mapear(maps.first);
  }

  @override
  Future<Usuario?> obtenerUsuarioActual() async {
    final maps = await _db.db.query('usuarios', limit: 1);
    if (maps.isEmpty) return null;
    return _mapear(maps.first);
  }

  Usuario _mapear(Map<String, dynamic> m) => Usuario(
        id: m['id'] as int,
        username: m['username'] as String,
        passwordHash: m['password_hash'] as String,
        fechaCreacion: DateTime.parse(m['fecha_creacion'] as String),
      );
}
