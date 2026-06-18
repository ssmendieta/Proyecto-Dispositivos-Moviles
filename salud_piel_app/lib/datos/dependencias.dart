import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../dominio/casos_uso/escaneo_caso_uso.dart';
import '../dominio/casos_uso/gemini_caso_uso.dart';
import '../dominio/casos_uso/producto_caso_uso.dart';
import '../dominio/casos_uso/rutina_caso_uso.dart';
import '../dominio/utilidades/resultado.dart';

import 'datos/app_database.dart';
import 'providers/dependencias_provider.dart';
import 'repositorios/auth_repositorio.dart';
import 'repositorios/diagnostico_repositorio.dart';
import 'repositorios/producto_repositorio.dart';
import 'repositorios/rutina_repositorio.dart';
import 'servicios/gemini_servicio.dart';
import 'servicios/ml_servicio.dart';
import 'servicios/unsplash_servicio.dart';

class Dependencias {
  static Future<AppDependencias> init() async {
    final appDb = AppDatabase();
    await appDb.inicializar();

    final authRepositorio = AuthRepositorio(appDb);
    final diagnosticoRepositorio = DiagnosticoRepositorio(appDb);
    final productoRepositorio = ProductoRepositorio(appDb);
    final rutinaRepositorio = RutinaRepositorio(appDb);

    await productoRepositorio.precargarSemilla();
    await _cargarImagenesUnsplash(productoRepositorio);

    final mlServicio = MlServicio();
    await mlServicio.init();

    final geminiServicio = GeminiServicio(
      repositorio: productoRepositorio,
    );

    final autenticacionCasoUso = AutenticacionCasoUso(
      repositorio: authRepositorio,
    );

    final diagnosticoCasoUso = DiagnosticoCasoUso(
      repositorio: diagnosticoRepositorio,
    );

    final rutinaCasoUso = RutinaCasoUso(
      repositorio: rutinaRepositorio,
    );

    final productoCasoUso = ProductoCasoUso(
      repositorio: productoRepositorio,
    );

    final escaneoCasoUso = EscaneoCasoUso(
      mlServicio: mlServicio,
    );

    final geminiCasoUso = GeminiCasoUso(
      servicio: geminiServicio,
    );

    return AppDependencias(
      appDatabase: appDb,
      authRepositorio: authRepositorio,
      diagnosticoRepositorio: diagnosticoRepositorio,
      productoRepositorio: productoRepositorio,
      rutinaRepositorio: rutinaRepositorio,
      mlServicio: mlServicio,
      geminiServicio: geminiServicio,
      autenticacionCasoUso: autenticacionCasoUso,
      diagnosticoCasoUso: diagnosticoCasoUso,
      rutinaCasoUso: rutinaCasoUso,
      productoCasoUso: productoCasoUso,
      escaneoCasoUso: escaneoCasoUso,
      geminiCasoUso: geminiCasoUso,
    );
  }

  static Future<void> _cargarImagenesUnsplash(
    ProductoRepositorio repo,
  ) async {
    final accessKey = dotenv.env['UNSPLASH_ACCESS_KEY'];

    if (accessKey == null || accessKey.isEmpty) {
      return;
    }

    final unsplash = UnsplashServicio(
      accessKey: accessKey,
    );

    final resultado = await repo.listar();

    if (resultado case Exito(:final data)) {
      final productos = data
          .where(
            (producto) =>
                producto.imagenPath != null &&
                producto.imagenPath!.contains('picsum'),
          )
          .toList();

      for (final producto in productos) {
        final query = '${producto.marca ?? ''} ${producto.nombre}';
        final url = await unsplash.buscarImagen(query);

        if (url != null) {
          await repo.actualizarImagenPath(
            producto.id,
            url,
          );
        }
      }
    }

    unsplash.dispose();
  }
}