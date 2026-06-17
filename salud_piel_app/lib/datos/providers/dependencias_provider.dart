import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../dominio/casos_uso/escaneo_caso_uso.dart';
import '../../dominio/casos_uso/gemini_caso_uso.dart';
import '../../dominio/casos_uso/producto_caso_uso.dart';
import '../../dominio/casos_uso/rutina_caso_uso.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../../dominio/repositorios/i_gemini_servicio.dart';
import '../../dominio/repositorios/i_ml_servicio.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/repositorios/i_rutina_repositorio.dart';
import '../datos/app_database.dart';

class AppDependencias {
  final AppDatabase appDatabase;

  final IAuthRepositorio authRepositorio;
  final IDiagnosticoRepositorio diagnosticoRepositorio;
  final IProductoRepositorio productoRepositorio;
  final IRutinaRepositorio rutinaRepositorio;

  final IMlServicio mlServicio;
  final IGeminiServicio geminiServicio;

  final AutenticacionCasoUso autenticacionCasoUso;
  final DiagnosticoCasoUso diagnosticoCasoUso;
  final RutinaCasoUso rutinaCasoUso;
  final ProductoCasoUso productoCasoUso;
  final EscaneoCasoUso escaneoCasoUso;
  final GeminiCasoUso geminiCasoUso;

  const AppDependencias({
    required this.appDatabase,
    required this.authRepositorio,
    required this.diagnosticoRepositorio,
    required this.productoRepositorio,
    required this.rutinaRepositorio,
    required this.mlServicio,
    required this.geminiServicio,
    required this.autenticacionCasoUso,
    required this.diagnosticoCasoUso,
    required this.rutinaCasoUso,
    required this.productoCasoUso,
    required this.escaneoCasoUso,
    required this.geminiCasoUso,
  });
}

final appDependenciasProvider = Provider<AppDependencias>((ref) {
  throw UnimplementedError(
    'appDependenciasProvider debe ser sobreescrito en ProviderScope.',
  );
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(appDependenciasProvider).appDatabase;
});

final authRepositorioProvider = Provider<IAuthRepositorio>((ref) {
  return ref.watch(appDependenciasProvider).authRepositorio;
});

final diagnosticoRepositorioProvider = Provider<IDiagnosticoRepositorio>((ref) {
  return ref.watch(appDependenciasProvider).diagnosticoRepositorio;
});

final productoRepositorioProvider = Provider<IProductoRepositorio>((ref) {
  return ref.watch(appDependenciasProvider).productoRepositorio;
});

final rutinaRepositorioProvider = Provider<IRutinaRepositorio>((ref) {
  return ref.watch(appDependenciasProvider).rutinaRepositorio;
});

final mlServicioProvider = Provider<IMlServicio>((ref) {
  return ref.watch(appDependenciasProvider).mlServicio;
});

final geminiServicioProvider = Provider<IGeminiServicio>((ref) {
  return ref.watch(appDependenciasProvider).geminiServicio;
});

final autenticacionCasoUsoProvider = Provider<AutenticacionCasoUso>((ref) {
  return ref.watch(appDependenciasProvider).autenticacionCasoUso;
});

final diagnosticoCasoUsoProvider = Provider<DiagnosticoCasoUso>((ref) {
  return ref.watch(appDependenciasProvider).diagnosticoCasoUso;
});

final rutinaCasoUsoProvider = Provider<RutinaCasoUso>((ref) {
  return ref.watch(appDependenciasProvider).rutinaCasoUso;
});

final productoCasoUsoProvider = Provider<ProductoCasoUso>((ref) {
  return ref.watch(appDependenciasProvider).productoCasoUso;
});

final escaneoCasoUsoProvider = Provider<EscaneoCasoUso>((ref) {
  return ref.watch(appDependenciasProvider).escaneoCasoUso;
});

final geminiCasoUsoProvider = Provider<GeminiCasoUso>((ref) {
  return ref.watch(appDependenciasProvider).geminiCasoUso;
});