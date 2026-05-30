class Usuario {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final DateTime fechaCreacion;
  final int? edad;
  final String? sexo;
  final String? tipoPiel;
  final String? condicionesMedicas;

  Usuario({
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
}
