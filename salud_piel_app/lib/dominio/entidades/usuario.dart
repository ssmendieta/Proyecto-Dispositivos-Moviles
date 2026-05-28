class Usuario {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final DateTime fechaCreacion;

  Usuario({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.fechaCreacion,
  });
}
