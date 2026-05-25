import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constantes/colores.dart';
import '../../inicio/controladores/inicio_controlador.dart';

import '../controladores/rutinas_controlador.dart';
import 'gestionar_rutina_pantalla.dart';

class RutinasPantalla extends StatelessWidget {
  const RutinasPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = Get.find<RutinasControlador>();

    final inicioControlador =
        Get.find<InicioControlador>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColoresApp.fondo,

        floatingActionButton: FloatingActionButton(
          onPressed: () {

            inicioControlador.cambiarPagina(3);
          },

          backgroundColor: ColoresApp.primario,

          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),

        body: Obx(() {

          final totalProductos =
              controlador.rutinaManana.length +
              controlador.rutinaNoche.length;

          final completadosManana =
              controlador.rutinaManana
                  .where(
                    (producto) =>
                        producto['completado'] == true,
                  )
                  .length;

          final completadosNoche =
              controlador.rutinaNoche
                  .where(
                    (producto) =>
                        producto['completado'] == true,
                  )
                  .length;

          final totalCompletados =
              completadosManana +
              completadosNoche;

          final progreso =
              totalProductos == 0
                  ? 0.0
                  : totalCompletados / totalProductos;

          final filtro =
              controlador.filtroSeleccionado.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// HEADER
                Row(
                  children: [

                    const CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          Color(0xFFE6D5F7),

                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'SkinGPT',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            ColoresApp
                                .textoPrincipal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// CUIDADO DEL DIA
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                          22,
                        ),
                  ),

                  child: Row(
                    children: [

                      SizedBox(
                        width: 70,
                        height: 70,

                        child: Stack(
                          alignment:
                              Alignment.center,

                          children: [

                            CircularProgressIndicator(
                              value: progreso,

                              strokeWidth: 8,

                              backgroundColor:
                                  Colors
                                      .grey
                                      .shade200,

                              valueColor:
                                  AlwaysStoppedAnimation(
                                    ColoresApp
                                        .primario,
                                  ),
                            ),

                            Text(
                              '${(progreso * 100).round()}%',

                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    ColoresApp
                                        .textoPrincipal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              'Cuidado del Día',

                              style: TextStyle(
                                fontSize: 20,

                                fontWeight:
                                    FontWeight
                                        .bold,

                                color:
                                    ColoresApp
                                        .textoPrincipal,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              totalProductos == 0
                                  ? 'Agrega productos para comenzar tu rutina.'
                                  : '¡Excelente progreso! Has completado $totalCompletados de $totalProductos pasos.',

                              style: TextStyle(
                                color:
                                    ColoresApp
                                        .textoSecundario,

                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// FILTROS
                Row(
                  children: [

                    _chipFiltro(
                      texto: 'Todas',

                      seleccionado:
                          filtro == 'Todas',

                      onTap:
                          () => controlador
                              .cambiarFiltro(
                                'Todas',
                              ),
                    ),

                    const SizedBox(width: 10),

                    _chipFiltro(
                      texto: 'Mañana',

                      seleccionado:
                          filtro == 'Mañana',

                      onTap:
                          () => controlador
                              .cambiarFiltro(
                                'Mañana',
                              ),
                    ),

                    const SizedBox(width: 10),

                    _chipFiltro(
                      texto: 'Noche',

                      seleccionado:
                          filtro == 'Noche',

                      onTap:
                          () => controlador
                              .cambiarFiltro(
                                'Noche',
                              ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// MAÑANA
                if (filtro == 'Todas' ||
                    filtro == 'Mañana') ...[

                  _tituloSeccion(
                    titulo: 'MAÑANA',

                    icono:
                        Icons.wb_sunny_outlined,

                    textoDerecha:
                        controlador
                                .rutinaManana
                                .isEmpty
                            ? ''
                            : '$completadosManana/${controlador.rutinaManana.length} Pasos',
                  ),

                  const SizedBox(height: 12),

                  _listaRutina(
                    productos:
                        controlador
                            .rutinaManana,

                    vacio:
                        'No tienes productos en la rutina de mañana.',

                    onToggle:
                        controlador.toggleManana,
                  ),

                  const SizedBox(height: 22),
                ],

                /// NOCHE
                if (filtro == 'Todas' ||
                    filtro == 'Noche') ...[

                  _tituloSeccion(
                    titulo: 'NOCHE',

                    icono:
                        Icons.nightlight_round,

                    textoDerecha:
                        controlador
                                .rutinaNoche
                                .isEmpty
                            ? ''
                            : '$completadosNoche/${controlador.rutinaNoche.length} Pasos',
                  ),

                  const SizedBox(height: 12),

                  _listaRutina(
                    productos:
                        controlador
                            .rutinaNoche,

                    vacio:
                        'No tienes productos en la rutina de noche.',

                    onToggle:
                        controlador.toggleNoche,
                  ),

                  const SizedBox(height: 22),
                ],

                /// EDITAR
                TextButton.icon(
                  onPressed: () {

                    Get.to(
                      () =>
                          const GestionarRutinaPantalla(),
                    );
                  },

                  icon: const Icon(
                    Icons.edit_outlined,
                  ),

                  label: const Text(
                    'Editar rutina',
                  ),

                  style: TextButton.styleFrom(
                    foregroundColor:
                        ColoresApp.primario,
                  ),
                ),

                const SizedBox(height: 90),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _chipFiltro({
    required String texto,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(24),

      child: Container(
        padding:
            const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 10,
            ),

        decoration: BoxDecoration(
          color:
              seleccionado
                  ? ColoresApp.primario
                  : Colors.white,

          borderRadius:
              BorderRadius.circular(24),
        ),

        child: Text(
          texto,

          style: TextStyle(
            color:
                seleccionado
                    ? Colors.white
                    : ColoresApp
                        .textoPrincipal,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _tituloSeccion({
    required String titulo,
    required IconData icono,
    required String textoDerecha,
  }) {
    return Row(
      children: [

        Icon(
          icono,
          size: 18,
          color: ColoresApp.textoSecundario,
        ),

        const SizedBox(width: 8),

        Text(
          titulo,

          style: TextStyle(
            fontWeight: FontWeight.bold,

            color:
                ColoresApp.textoSecundario,

            letterSpacing: 1,
          ),
        ),

        const Spacer(),

        Text(
          textoDerecha,

          style: TextStyle(
            fontWeight: FontWeight.bold,

            color: ColoresApp.primario,

            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _listaRutina({
    required List<Map<String, dynamic>>
    productos,

    required String vacio,

    required Function(int) onToggle,
  }) {
    if (productos.isEmpty) {
      return Container(
        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(18),
        ),

        child: Text(
          vacio,

          style: TextStyle(
            color:
                ColoresApp.textoSecundario,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        productos.length,

        (index) {

          final producto =
              productos[index];

          return Container(
            margin:
                const EdgeInsets.only(
                  bottom: 12,
                ),

            padding:
                const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
            ),

            child: Row(
              children: [

                Container(
                  width: 58,
                  height: 58,

                  decoration: BoxDecoration(
                    color: ColoresApp.fondo,

                    borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                  ),

                  child: const Icon(
                    Icons.spa_outlined,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(
                        producto['nombre'],

                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,

                          fontSize: 16,

                          color:
                              ColoresApp
                                  .textoPrincipal,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        producto['marca'],

                        style: TextStyle(
                          color:
                              ColoresApp
                                  .textoSecundario,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap:
                      () => onToggle(index),

                  child: Container(
                    width: 34,
                    height: 34,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color:
                          producto['completado']
                              ? ColoresApp
                                  .exito
                              : Colors
                                  .transparent,

                      border: Border.all(
                        color:
                            producto['completado']
                                ? ColoresApp
                                    .exito
                                : Colors
                                    .grey
                                    .shade400,

                        width: 2,
                      ),
                    ),

                    child:
                        producto['completado']
                            ? const Icon(
                              Icons.check,

                              color:
                                  Colors.white,

                              size: 20,
                            )
                            : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}