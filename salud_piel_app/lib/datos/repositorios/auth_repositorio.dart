import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';
import '../datos/app_database.dart';
import '../modelos/usuario_dto.dart';

class AuthRepositorio implements IAuthRepositorio {
  final AppDatabase _db;
  AuthRepositorio(this._db);

  @override
  Future<Resultado<Usuario>> registrar(
    String username,
    String email,
    String password, {
    int? edad,
    String? sexo,
    String? tipoPiel,
    String? condicionesMedicas,
  }) async {
    final hash = sha256.convert(utf8.encode(password)).toString();
    final now = DateTime.now().toIso8601String();

    final existente = await _db.db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    if (existente.isNotEmpty) {
      return Fracaso('El correo electrónico ya está registrado');
    }

    try {
      final id = await _db.db.insert('usuarios', {
        'username': username,
        'email': email,
        'password_hash': hash,
        'fecha_creacion': now,
        if (edad != null) 'edad': edad,
        if (sexo != null) 'sexo': sexo,
        if (tipoPiel != null) 'tipo_piel': tipoPiel,
        if (condicionesMedicas != null) 'condiciones_medicas': condicionesMedicas,
      });
      return Exito(Usuario(
        id: id,
        username: username,
        email: email,
        passwordHash: hash,
        fechaCreacion: DateTime.parse(now),
        edad: edad,
        sexo: sexo,
        tipoPiel: tipoPiel,
        condicionesMedicas: condicionesMedicas,
      ));
    } catch (e) {
      return Fracaso('Error al registrar usuario: ${e.toString()}', e is Exception ? e : null);
    }
  }

  @override
  Future<Resultado<Usuario>> login(String email, String password) async {
    final hash = sha256.convert(utf8.encode(password)).toString();
    final maps = await _db.db.query(
      'usuarios',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email, hash],
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
