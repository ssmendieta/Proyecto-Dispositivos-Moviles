import 'package:get/get.dart';
import '../../datos/datos/app_database.dart';
import '../../datos/repositorios/auth_repositorio.dart';
import '../../datos/repositorios/diagnostico_repositorio.dart';
import '../../datos/repositorios/producto_repositorio.dart';
import '../../datos/repositorios/rutina_repositorio.dart';
import '../../dominio/repositorios/i_auth_repositorio.dart';
import '../../dominio/repositorios/i_diagnostico_repositorio.dart';
import '../../dominio/repositorios/i_producto_repositorio.dart';
import '../../dominio/repositorios/i_rutina_repositorio.dart';
import 'auth_servicio.dart';
import 'ml_servicio.dart';

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

    await Get.putAsync(() => MlServicio().init());
    Get.put(AuthServicio());
  }
}
