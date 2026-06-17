import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../dominio/casos_uso/autenticacion_caso_uso.dart';
import '../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../dominio/casos_uso/escaneo_caso_uso.dart';
import '../dominio/casos_uso/gemini_caso_uso.dart';
import '../dominio/casos_uso/producto_caso_uso.dart';
import '../dominio/casos_uso/rutina_caso_uso.dart';
import '../dominio/repositorios/i_auth_repositorio.dart';
import '../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../dominio/repositorios/i_gemini_servicio.dart';
import '../dominio/repositorios/i_ml_servicio.dart';
import '../dominio/repositorios/i_producto_repositorio.dart';
import '../dominio/repositorios/i_rutina_repositorio.dart';
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

    final dependencias = AppDependencias(
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

    _registrarCompatibilidadGetX(dependencias);

    return dependencias;
  }

  static void _registrarCompatibilidadGetX(AppDependencias dependencias) {
    Get.put<AppDatabase>(dependencias.appDatabase);

    Get.put<IAuthRepositorio>(dependencias.authRepositorio);
    Get.put<IDiagnosticoRepositorio>(dependencias.diagnosticoRepositorio);
    Get.put<IProductoRepositorio>(dependencias.productoRepositorio);
    Get.put<IRutinaRepositorio>(dependencias.rutinaRepositorio);

    Get.put<IMlServicio>(dependencias.mlServicio);
    Get.put<IGeminiServicio>(dependencias.geminiServicio);
  }

  static Future<void> _cargarImagenesUnsplash(ProductoRepositorio repo) async {
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