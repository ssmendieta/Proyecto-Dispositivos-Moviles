import '../enumeraciones/momento_rutina.dart';
import '../entidades/rutina.dart';

abstract class IRutinaRepositorio {
  Future<int> crear(String nombre, MomentoRutina momento);
  Future<Rutina?> obtener(int id);
  Future<List<Rutina>> listar();
  Future<void> actualizar(Rutina rutina);
  Future<void> eliminar(int id);
  Future<void> agregarProducto(int rutinaId, int productoId, int orden);
  Future<void> quitarProducto(int rutinaId, int productoId);
  Future<void> marcarCompletado(int rutinaId, int productoId, bool completado);
}
