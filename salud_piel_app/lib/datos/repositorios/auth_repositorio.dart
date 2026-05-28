import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../../nucleo/utilidades/resultado.dart';
import '../datos/app_database.dart';
import '../modelos/usuario_dto.dart';

class AuthRepositorio implements IAuthRepositorio {
  final AppDatabase _db;
  AuthRepositorio(this._db);

  @override
  Future<Resultado<Usuario>> registrar(String username, String password) async {
    final hash = sha256.convert(utf8.encode(password)).toString();
    final now = DateTime.now().toIso8601String();
    try {
      final id = await _db.db.insert('usuarios', {
        'username': username,
        'password_hash': hash,
        'fecha_creacion': now,
      });
      return Exito(Usuario(
        id: id,
        username: username,
        passwordHash: hash,
        fechaCreacion: DateTime.parse(now),
      ));
    } catch (e) {
      return Fracaso('Error al registrar usuario: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Usuario>> login(String username, String password) async {
    final hash = sha256.convert(utf8.encode(password)).toString();
    final maps = await _db.db.query(
      'usuarios',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, hash],
    );
    if (maps.isEmpty) return Fracaso('Credenciales incorrectas');
    return Exito(_mapear(maps.first));
  }

  @override
  Future<Resultado<Usuario>> obtenerUsuarioActual() async {
    final maps = await _db.db.query('usuarios', limit: 1);
    if (maps.isEmpty) return Fracaso('No hay sesión activa');
    return Exito(_mapear(maps.first));
  }

  Usuario _mapear(Map<String, dynamic> m) =>
      UsuarioDto.fromMap(m).toEntity();
}
