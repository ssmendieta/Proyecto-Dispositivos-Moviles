import '../entidades/producto.dart';
import '../entidades/rutina.dart';
import '../enumeraciones/momento_rutina.dart';
import '../repositorios/i_rutina_repositorio.dart';
import '../../dominio/utilidades/resultado.dart';

class RutinaCasoUso {
  final IRutinaRepositorio _repositorio;

  static const int _maxProductosPorRutina = 10;

  RutinaCasoUso({required IRutinaRepositorio repositorio})
      : _repositorio = repositorio;

  Future<Resultado<List<Rutina>>> listarRutinas() {
    return _repositorio.listar();
  }

  Future<Resultado<Null>> agregarProductoARutina(
    MomentoRutina momento,
    Producto producto,
  ) async {
    if (producto.nombre.isEmpty) {
      return const Fracaso('El producto debe tener un nombre');
    }

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
        final yaExiste = rutina.productos.any((rp) => rp.producto.id == producto.id);
        if (yaExiste) {
          return Fracaso('Este producto ya está en la rutina');
        }

        if (rutina.productos.length >= _maxProductosPorRutina) {
          return Fracaso('La rutina ya tiene el máximo de $_maxProductosPorRutina productos');
        }

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
  ) async {
    if (rutinaId <= 0) {
      return const Fracaso('El identificador de la rutina no es válido');
    }
    if (productoId <= 0) {
      return const Fracaso('El identificador del producto no es válido');
    }
    return _repositorio.marcarCompletado(rutinaId, productoId, completado);
  }

  Future<Resultado<Null>> quitarProducto(int rutinaId, int productoId) async {
    if (rutinaId <= 0) {
      return const Fracaso('El identificador de la rutina no es válido');
    }
    if (productoId <= 0) {
      return const Fracaso('El identificador del producto no es válido');
    }
    return _repositorio.quitarProducto(rutinaId, productoId);
  }

  Future<Resultado<Null>> reordenarProductos(
    int rutinaId,
    List<RutinaProducto> productos,
  ) async {
    if (rutinaId <= 0) {
      return const Fracaso('El identificador de la rutina no es válido');
    }
    if (productos.isEmpty) {
      return const Fracaso('No hay productos para reordenar');
    }
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
