import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../constantes/colores.dart';
import '../pantallas/detalle_historial_pantalla.dart';

String _derivarEstado(double confianza) {
  if (confianza >= 0.95) return 'ESTABLE';
  if (confianza >= 0.80) return 'SEGUIMIENTO';
  return 'ATENCIÓN';
}

Color _colorEstado(String estado) {
  switch (estado) {
    case 'ESTABLE':
      return Colors.green;
    case 'SEGUIMIENTO':
      return Colors.blue;
    default:
      return Colors.orange;
  }
}

class TarjetaHistorial extends StatelessWidget {
  final Diagnostico diagnostico;

  const TarjetaHistorial({
    super.key,
    required this.diagnostico,
  });

  @override
  Widget build(BuildContext context) {
    final estado = _derivarEstado(diagnostico.confianza);
    final colorEstado = _colorEstado(estado);
    final progreso = diagnostico.confianza;
    final fechaFormateada = DateFormat('dd MMM yyyy').format(diagnostico.fecha);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.to(
          () => DetalleHistorialPantalla(
            diagnostico: diagnostico,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: colorEstado,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: [
                              colorEstado.withValues(alpha: 0.25),
                              ColoresApp.fondo,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.image_search,
                          size: 34,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    diagnostico.condicion.displayName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: ColoresApp.textoPrincipal,
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorEstado.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    estado,
                                    style: TextStyle(
                                      color: colorEstado,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(
                              fechaFormateada,
                              style: TextStyle(
                                color: ColoresApp.textoSecundario,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: LinearProgressIndicator(
                                      value: progreso,
                                      minHeight: 7,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation(
                                        ColoresApp.primario,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  '${(progreso * 100).round()}% Confianza',
                                  style: TextStyle(
                                    color: ColoresApp.primario,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Toca para ver detalle',
                              style: TextStyle(
                                color: ColoresApp.textoSecundario,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}