import '../entidades/detalle_producto_ia.dart';
import '../entidades/informacion_condicion.dart';
import '../entidades/producto.dart';
import '../enumeraciones/condicion_piel.dart';

abstract class IGeminiServicio {
  Future<InformacionCondicion?> informacionCondicion({
    required CondicionPiel condicion,
    double confianza = 0.0,
  });

  Future<DetalleProductoIA?> detalleProductoIA(Producto producto);

  String? get ultimoError;
}
