import '../entidades/detalle_producto_ia.dart';
import '../entidades/informacion_condicion.dart';
import '../entidades/producto.dart';
import '../enumeraciones/condicion_piel.dart';
import '../repositorios/i_gemini_servicio.dart';

class GeminiCasoUso {
  final IGeminiServicio _servicio;

  GeminiCasoUso({required IGeminiServicio servicio}) : _servicio = servicio;

  Future<InformacionCondicion?> obtenerInformacionCondicion(
    CondicionPiel condicion, {
    double confianza = 0.0,
  }) async {
    if (condicion == CondicionPiel.normal) return null;
    return _servicio.informacionCondicion(
      condicion: condicion,
      confianza: confianza,
    );
  }

  Future<DetalleProductoIA?> analizarProducto(Producto producto) {
    return _servicio.detalleProductoIA(producto);
  }

  String? get ultimoError => _servicio.ultimoError;
}
