import 'package:flutter/foundation.dart';

import '../../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../../dominio/entidades/usuario.dart';
import '../../../dominio/utilidades/resultado.dart';

class SesionMemoria {
  static Usuario? usuarioActual;
  static bool sesionIniciada = false;
  static bool cargando = false;

  static String get nombreUsuario =>
      usuarioActual?.username ?? 'Usuario';

  static void iniciarSesion(Usuario usuario) {
    usuarioActual = usuario;
    sesionIniciada = true;
    cargando = false;
  }

  static void cerrarSesion() {
    usuarioActual = null;
    sesionIniciada = false;
    cargando = false;
  }
}

class SesionValor<T> extends ValueNotifier<T> {
  final void Function(T valor) alCambiar;

  SesionValor(
    super.value, {
    required this.alCambiar,
  });

  @override
  set value(T nuevoValor) {
    super.value = nuevoValor;
    alCambiar(nuevoValor);
  }
}

class SesionControlador {
  final AutenticacionCasoUso _casoUso;

  SesionControlador({
    required AutenticacionCasoUso casoUso,
  }) : _casoUso = casoUso;

  late final usuarioActual = SesionValor<Usuario?>(
    SesionMemoria.usuarioActual,
    alCambiar: (valor) {
      SesionMemoria.usuarioActual = valor;
    },
  );

  late final sesionIniciada = SesionValor<bool>(
    SesionMemoria.sesionIniciada,
    alCambiar: (valor) {
      SesionMemoria.sesionIniciada = valor;
    },
  );

  late final cargando = SesionValor<bool>(
    SesionMemoria.cargando,
    alCambiar: (valor) {
      SesionMemoria.cargando = valor;
    },
  );

  String get nombreUsuario => SesionMemoria.nombreUsuario;

  Future<bool> registrar(
    String username,
    String email,
    String password,
  ) async {
    cargando.value = true;

    final resultado = await _casoUso.registrar(
      username,
      email,
      password,
    );

    switch (resultado) {
      case Exito<Usuario>():
        usuarioActual.value = resultado.data;
        sesionIniciada.value = true;
        cargando.value = false;
        return true;

      case Fracaso<Usuario>():
        cargando.value = false;
        return false;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    cargando.value = true;

    final resultado = await _casoUso.login(
      email,
      password,
    );

    switch (resultado) {
      case Exito<Usuario>():
        usuarioActual.value = resultado.data;
        sesionIniciada.value = true;
        cargando.value = false;
        return true;

      case Fracaso<Usuario>():
        cargando.value = false;
        return false;
    }
  }

  void cerrarSesion() {
    usuarioActual.value = null;
    sesionIniciada.value = false;
    cargando.value = false;
  }

  Future<void> verificarSesion() async {
    final resultado = await _casoUso.verificarSesion();

    switch (resultado) {
      case Exito<Usuario>():
        usuarioActual.value = resultado.data;
        sesionIniciada.value = true;

      case Fracaso<Usuario>():
        usuarioActual.value = null;
        sesionIniciada.value = false;
    }
  }
}