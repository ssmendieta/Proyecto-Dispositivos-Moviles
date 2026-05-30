import '../../dominio/entidades/usuario.dart';

class UsuarioDto {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final String fechaCreacion;
  final int? edad;
  final String? sexo;
  final String? tipoPiel;
  final String? condicionesMedicas;

  const UsuarioDto({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.fechaCreacion,
    this.edad,
    this.sexo,
    this.tipoPiel,
    this.condicionesMedicas,
  });

  factory UsuarioDto.fromMap(Map<String, dynamic> m) => UsuarioDto(
        id: m['id'] as int,
        username: m['username'] as String,
        email: m['email'] as String? ?? '',
        passwordHash: m['password_hash'] as String,
        fechaCreacion: m['fecha_creacion'] as String,
        edad: m['edad'] as int?,
        sexo: m['sexo'] as String?,
        tipoPiel: m['tipo_piel'] as String?,
        condicionesMedicas: m['condiciones_medicas'] as String?,
      );

  factory UsuarioDto.fromEntity(Usuario e) => UsuarioDto(
        id: e.id,
        username: e.username,
        email: e.email,
        passwordHash: e.passwordHash,
        fechaCreacion: e.fechaCreacion.toIso8601String(),
        edad: e.edad,
        sexo: e.sexo,
        tipoPiel: e.tipoPiel,
        condicionesMedicas: e.condicionesMedicas,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'password_hash': passwordHash,
        'fecha_creacion': fechaCreacion,
        if (edad != null) 'edad': edad,
        if (sexo != null) 'sexo': sexo,
        if (tipoPiel != null) 'tipo_piel': tipoPiel,
        if (condicionesMedicas != null) 'condiciones_medicas': condicionesMedicas,
      };

  Usuario toEntity() => Usuario(
        id: id,
        username: username,
        email: email,
        passwordHash: passwordHash,
        fechaCreacion: DateTime.parse(fechaCreacion),
        edad: edad,
        sexo: sexo,
        tipoPiel: tipoPiel,
        condicionesMedicas: condicionesMedicas,
      );
}
