import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dominio/entidades/producto.dart';
import '../../constantes/colores.dart';
import '../../rutinas/controladores/rutinas_provider.dart';

class AgregarARutinaSheet extends ConsumerStatefulWidget {
  final Producto producto;

  const AgregarARutinaSheet({
    super.key,
    required this.producto,
  });

  @override
  ConsumerState<AgregarARutinaSheet> createState() =>
      _AgregarARutinaSheetState();
}

class _AgregarARutinaSheetState extends ConsumerState<AgregarARutinaSheet> {
  bool mananaSeleccionada = false;
  bool nocheSeleccionada = false;
  bool guardando = false;

  void _mostrarMensaje(
    String titulo,
    String mensaje, {
    Color? color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$titulo\n$mensaje'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
      ),
    );
  }

  Future<void> _confirmar() async {
    if (!mananaSeleccionada && !nocheSeleccionada) {
      _mostrarMensaje(
        'Selecciona una rutina',
        'Debes elegir mañana o noche.',
        color: Colors.orange,
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await ref.read(rutinasProvider.notifier).agregarProducto(
          producto: widget.producto,
          manana: mananaSeleccionada,
          noche: nocheSeleccionada,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      guardando = false;
    });

    navigator.pop();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Producto añadido\n${widget.producto.nombre} fue añadido correctamente.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'Añadir a mi rutina',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColoresApp.textoPrincipal,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.producto.nombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresApp.textoSecundario,
              ),
            ),

            const SizedBox(height: 24),

            _opcionRutina(
              icono: Icons.wb_sunny_outlined,
              titulo: 'Rutina de Mañana',
              descripcion:
                  'Ideal para limpieza, hidratación y protección solar',
              seleccionado: mananaSeleccionada,
              onTap: () {
                setState(() {
                  mananaSeleccionada = !mananaSeleccionada;
                });
              },
            ),

            const SizedBox(height: 12),

            _opcionRutina(
              icono: Icons.nightlight_round,
              titulo: 'Rutina de Noche',
              descripcion: 'Ideal para reparación, tratamiento y nutrición',
              seleccionado: nocheSeleccionada,
              onTap: () {
                setState(() {
                  nocheSeleccionada = !nocheSeleccionada;
                });
              },
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: guardando ? null : _confirmar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.primario,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Confirmar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcionRutina({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: seleccionado
              ? ColoresApp.acento.withValues(alpha: 0.18)
              : ColoresApp.fondo,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seleccionado ? ColoresApp.acento : ColoresApp.borde,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icono,
              color: seleccionado ? ColoresApp.acento : ColoresApp.primario,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.textoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: seleccionado,
              onChanged: (_) {
                onTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}