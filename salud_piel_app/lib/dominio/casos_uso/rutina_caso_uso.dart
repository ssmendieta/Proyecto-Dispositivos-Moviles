import '../entidades/producto.dart';
import '../entidades/rutina.dart';
import '../enumeraciones/momento_rutina.dart';
import '../repositorios/i_rutina_repositorio.dart';
import '../../nucleo/utilidades/resultado.dart';

class RutinaCasoUso {
  final IRutinaRepositorio _repositorio;

  RutinaCasoUso({required IRutinaRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<List<Rutina>>> listarRutinas() {
    return _repositorio.listar();
  }

  Future<Resultado<Null>> agregarProductoARutina(
    MomentoRutina momento,
    Producto producto,
  ) async {
    final rutinas = await _repositorio.listar();
    if (rutinas case Exito<List<Rutina>>()) {
      var rutina = rutinas.data.where((r) => r.momento == momento).firstOrNull;

      if (rutina == null) {
        final nombre = momento == MomentoRutina.maniana
            ? 'Rutina Mañana'
            : 'Rutina Noche';
        final creado = await _repositorio.crear(nombre, momento);
        if (creado case Exito<int>()) {
          final obtenido = await _repositorio.obtener(creado.data);
          if (obtenido case Exito<Rutina>()) {
            rutina = obtenido.data;
          }
        }
      }

      if (rutina != null) {
        final orden = rutina.productos.length;
        return _repositorio.agregarProducto(rutina.id, producto.id, orden);
      }
    }
    return const Fracaso('No se pudo agregar el producto a la rutina.');
  }

  Future<Resultado<Null>> marcarCompletado(
    int rutinaId,
    int productoId,
    bool completado,
  ) {
    return _repositorio.marcarCompletado(rutinaId, productoId, completado);
  }

  Future<Resultado<Null>> quitarProducto(int rutinaId, int productoId) {
    return _repositorio.quitarProducto(rutinaId, productoId);
  }

  Future<Resultado<Null>> reordenarProductos(
    int rutinaId,
    List<RutinaProducto> productos,
  ) async {
    for (var i = 0; i < productos.length; i++) {
      final rp = productos[i];
      if (rp.orden != i) {
        final quitado = await _repositorio.quitarProducto(rutinaId, rp.producto.id);
        if (quitado case Fracaso<Null>()) {
          return quitado;
        }
        final agregado =
            await _repositorio.agregarProducto(rutinaId, rp.producto.id, i);
        if (agregado case Fracaso<Null>()) {
          return agregado;
        }
      }
    }
    return const Exito(null);
  }
}
