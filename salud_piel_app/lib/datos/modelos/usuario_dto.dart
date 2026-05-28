import '../../dominio/entidades/usuario.dart';

class UsuarioDto {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final String fechaCreacion;

  const UsuarioDto({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.fechaCreacion,
  });

  factory UsuarioDto.fromMap(Map<String, dynamic> m) => UsuarioDto(
        id: m['id'] as int,
        username: m['username'] as String,
        email: m['email'] as String? ?? '',
        passwordHash: m['password_hash'] as String,
        fechaCreacion: m['fecha_creacion'] as String,
      );

  factory UsuarioDto.fromEntity(Usuario e) => UsuarioDto(
        id: e.id,
        username: e.username,
        email: e.email,
        passwordHash: e.passwordHash,
        fechaCreacion: e.fechaCreacion.toIso8601String(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'password_hash': passwordHash,
        'fecha_creacion': fechaCreacion,
      };

  Usuario toEntity() => Usuario(
        id: id,
        username: username,
        email: email,
        passwordHash: passwordHash,
        fechaCreacion: DateTime.parse(fechaCreacion),
      );
}
