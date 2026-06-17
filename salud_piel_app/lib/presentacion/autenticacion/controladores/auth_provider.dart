import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../datos/providers/dependencias_provider.dart';
import '../../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../../dominio/entidades/usuario.dart';
import '../../../dominio/utilidades/resultado.dart';
import 'sesion_controlador.dart';

class SesionEstado {
  final Usuario? usuarioActual;
  final bool sesionIniciada;
  final bool cargando;

  const SesionEstado({
    required this.usuarioActual,
    required this.sesionIniciada,
    required this.cargando,
  });

  String get nombreUsuario => usuarioActual?.username ?? 'Usuario';

  SesionEstado copyWith({
    Usuario? usuarioActual,
    bool? sesionIniciada,
    bool? cargando,
  }) {
    return SesionEstado(
      usuarioActual: usuarioActual ?? this.usuarioActual,
      sesionIniciada: sesionIniciada ?? this.sesionIniciada,
      cargando: cargando ?? this.cargando,
    );
  }
}

class SesionNotifier extends StateNotifier<SesionEstado> {
  final AutenticacionCasoUso _casoUso;

  SesionNotifier({
    required AutenticacionCasoUso casoUso,
  })  : _casoUso = casoUso,
        super(
          SesionEstado(
            usuarioActual: SesionMemoria.usuarioActual,
            sesionIniciada: SesionMemoria.sesionIniciada,
            cargando: false,
          ),
        );

  void _establecerSesion(Usuario usuario) {
    SesionMemoria.iniciarSesion(usuario);

    state = SesionEstado(
      usuarioActual: usuario,
      sesionIniciada: true,
      cargando: false,
    );
  }

  Future<String?> login(String email, String password) async {
    state = state.copyWith(cargando: true);
    SesionMemoria.cargando = true;

    final resultado = await _casoUso.login(email, password);

    switch (resultado) {
      case Exito<Usuario>():
        _establecerSesion(resultado.data);
        return null;

      case Fracaso<Usuario>():
        state = state.copyWith(cargando: false);
        SesionMemoria.cargando = false;
        return resultado.mensaje;
    }
  }

  Future<String?> registrar(
    String username,
    String email,
    String password,
  ) async {
    state = state.copyWith(cargando: true);
    SesionMemoria.cargando = true;

    final resultado = await _casoUso.registrar(
      username,
      email,
      password,
    );

    switch (resultado) {
      case Exito<Usuario>():
        _establecerSesion(resultado.data);
        return null;

      case Fracaso<Usuario>():
        state = state.copyWith(cargando: false);
        SesionMemoria.cargando = false;
        return resultado.mensaje;
    }
  }

  Future<void> verificarSesion() async {
    state = state.copyWith(cargando: true);
    SesionMemoria.cargando = true;

    final resultado = await _casoUso.verificarSesion();

    switch (resultado) {
      case Exito<Usuario>():
        _establecerSesion(resultado.data);

      case Fracaso<Usuario>():
        SesionMemoria.cerrarSesion();

        state = const SesionEstado(
          usuarioActual: null,
          sesionIniciada: false,
          cargando: false,
        );
    }
  }

  void cerrarSesion() {
    SesionMemoria.cerrarSesion();

    state = const SesionEstado(
      usuarioActual: null,
      sesionIniciada: false,
      cargando: false,
    );
  }
}

final sesionProvider =
    StateNotifierProvider<SesionNotifier, SesionEstado>(
  (ref) {
    return SesionNotifier(
      casoUso: ref.watch(autenticacionCasoUsoProvider),
    );
  },
);