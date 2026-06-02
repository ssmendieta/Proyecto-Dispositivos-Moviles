import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../datos/datos/app_database.dart';
import '../../datos/repositorios/auth_repositorio.dart';
import '../../datos/repositorios/diagnostico_repositorio.dart';
import '../../datos/repositorios/producto_repositorio.dart';
import '../../datos/repositorios/rutina_repositorio.dart';
import '../../datos/servicios/gemini_servicio.dart';
import '../../datos/servicios/ml_servicio.dart';
import '../../datos/servicios/unsplash_servicio.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../../dominio/repositorios/i_ml_servicio.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/repositorios/i_rutina_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class Dependencias {
  static Future<void> init() async {
    final appDb = AppDatabase();
    await appDb.inicializar();
    Get.put(appDb);

    Get.put<IAuthRepositorio>(AuthRepositorio(appDb));
    Get.put<IDiagnosticoRepositorio>(DiagnosticoRepositorio(appDb));
    final productoRepo = ProductoRepositorio(appDb);
    Get.put<IProductoRepositorio>(productoRepo);
    Get.put<IRutinaRepositorio>(RutinaRepositorio(appDb));

    await productoRepo.precargarSemilla();
    await _cargarImagenesUnsplash(productoRepo);

    final mlServicio = MlServicio();
    await mlServicio.init();
    Get.put<IMlServicio>(mlServicio);

    Get.put<GeminiServicio>(GeminiServicio(
      repositorio: Get.find<IProductoRepositorio>(),
    ));
  }

  static Future<void> _cargarImagenesUnsplash(ProductoRepositorio repo) async {
    final accessKey = dotenv.env['UNSPLASH_ACCESS_KEY'];
    if (accessKey == null || accessKey.isEmpty) return;

    final unsplash = UnsplashServicio(accessKey: accessKey);
    final resultado = await repo.listar();

    if (resultado case Exito(:final data)) {
      final productos = data
          .where((p) => p.imagenPath != null && p.imagenPath!.contains('picsum'))
          .toList();

      for (final producto in productos) {
        final query = '${producto.marca ?? ''} ${producto.nombre}';
        final url = await unsplash.buscarImagen(query);
        if (url != null) {
          await repo.actualizarImagenPath(producto.id, url);
        }
      }
    }

    unsplash.dispose();
  }
}
