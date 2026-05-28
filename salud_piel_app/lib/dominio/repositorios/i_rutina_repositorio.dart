import '../../dominio/utilidades/resultado.dart';
import '../enumeraciones/momento_rutina.dart';
import '../entidades/rutina.dart';

abstract class IRutinaRepositorio {
  Future<Resultado<int>> crear(String nombre, MomentoRutina momento);
  Future<Resultado<Rutina>> obtener(int id);
  Future<Resultado<List<Rutina>>> listar();
  Future<Resultado<Null>> actualizar(Rutina rutina);
  Future<Resultado<Null>> eliminar(int id);
  Future<Resultado<Null>> agregarProducto(int rutinaId, int productoId, int orden);
  Future<Resultado<Null>> quitarProducto(int rutinaId, int productoId);
  Future<Resultado<Null>> marcarCompletado(int rutinaId, int productoId, bool completado);
}
