import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dominio/entidades/producto.dart';
import '../../../nucleo/servicios/gemini_servicio.dart';
import '../../constantes/colores.dart';
import '../widget/agregar_a_rutina_sheet.dart';

class DetalleProductoPantalla extends StatefulWidget {
  final Producto producto;

  const DetalleProductoPantalla({
    super.key,
    required this.producto,
  });

  @override
  State<DetalleProductoPantalla> createState() => _DetalleProductoPantallaState();
}

class _DetalleProductoPantallaState extends State<DetalleProductoPantalla> {
  DetalleProductoIA? _detalleIA;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarDetalleIA();
  }

  Future<void> _cargarDetalleIA() async {
    final producto = widget.producto;

    if (producto.instruccionesIA != null &&
        producto.instruccionesIA!.isNotEmpty) {
      try {
        final json = jsonDecode(producto.instruccionesIA!) as Map<String, dynamic>;
        _detalleIA = DetalleProductoIA(
          explicacionIngredientes: json['explicacionIngredientes'] as String? ?? '',
          beneficios: (json['beneficios'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          idealPara: json['idealPara'] as String? ?? '',
          advertencias: json['advertencias'] as String?,
          ratingIA: (json['ratingIA'] as num?)?.toDouble() ?? 0.0,
        );
        if (mounted) setState(() {});
        return;
      } catch (_) {}
    }

    setState(() => _cargando = true);
    final gemini = GeminiServicio();
    final detalle = await gemini.detalleProductoIA(producto);
    if (detalle != null) {
      _detalleIA = detalle;
    }
    if (mounted) setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final marca = producto.marca ?? 'Marca no especificada';
    final categoria = producto.categoria ?? 'Cuidado de la piel';
    final descripcion = producto.descripcion ??
        'Producto recomendado para apoyar una rutina personalizada de cuidado de la piel.';

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detalle del producto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(producto, marca, categoria),
            const SizedBox(height: 20),
            _seccionDescripcion(descripcion),
            _seccionModoUso(producto),
            if (_detalleIA != null) ...[
              const SizedBox(height: 16),
              _seccionBeneficios(_detalleIA!),
              if (_detalleIA!.explicacionIngredientes.isNotEmpty) ...[
                const SizedBox(height: 16),
                _seccionIngredientes(_detalleIA!),
              ],
              if (_detalleIA!.idealPara.isNotEmpty) ...[
                const SizedBox(height: 16),
                _seccionIdealPara(_detalleIA!),
              ],
              if (_detalleIA!.ratingIA > 0) ...[
                const SizedBox(height: 16),
                _seccionRating(_detalleIA!),
              ],
              if (_detalleIA!.advertencias != null &&
                  _detalleIA!.advertencias!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _seccionAdvertencias(_detalleIA!),
              ],
            ] else if (_cargando) ...[
              const SizedBox(height: 20),
              _seccionCargando(),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.bottomSheet(
                    AgregarARutinaSheet(producto: producto),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar a rutina'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.primario,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(Producto producto, String marca, String categoria) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: ColoresApp.fondo,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              Icons.spa_outlined,
              size: 60,
              color: ColoresApp.primario,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            producto.nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            marca,
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: ColoresApp.acento.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              categoria,
              style: TextStyle(
                color: ColoresApp.primario,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionDescripcion(String descripcion) {
    return _seccion(
      titulo: 'Descripción',
      icono: Icons.info_outline,
      contenido: descripcion,
    );
  }

  Widget _seccionBeneficios(DetalleProductoIA detalle) {
    return _seccionLista(
      titulo: 'Beneficios principales',
      icono: Icons.check_circle_outline,
      items: detalle.beneficios.isNotEmpty
          ? detalle.beneficios
          : ['Complementa la rutina diaria.', 'Recomendado según el tipo de piel y diagnóstico.'],
    );
  }

  Widget _seccionIngredientes(DetalleProductoIA detalle) {
    return _seccion(
      titulo: 'Ingredientes',
      icono: Icons.science_outlined,
      contenido: detalle.explicacionIngredientes,
    );
  }

  Widget _seccionIdealPara(DetalleProductoIA detalle) {
    return _seccion(
      titulo: 'Ideal para',
      icono: Icons.people_outline,
      contenido: detalle.idealPara,
    );
  }

  Widget _seccionRating(DetalleProductoIA detalle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF7B5EA7)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valoración IA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ...List.generate(5, (i) {
                final filled = i < detalle.ratingIA.round();
                return Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFB800),
                  size: 22,
                );
              }),
              const SizedBox(width: 6),
              Text(
                detalle.ratingIA.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionAdvertencias(DetalleProductoIA detalle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFE85757)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Advertencias',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detalle.advertencias!,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionCargando() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text(
            'Analizando producto con IA...',
            style: TextStyle(color: Color(0xFF888888), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _seccionModoUso(Producto producto) {
    final modo = producto.comoUsar ??
        'Aplicar según la indicación de la rutina. Evitar contacto con los ojos y suspender su uso si aparece irritación.';
    return _seccion(
      titulo: 'Modo de uso',
      icono: Icons.schedule_outlined,
      contenido: modo,
    );
  }

  Widget _seccion({
    required String titulo,
    required IconData icono,
    required String contenido,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: ColoresApp.primario),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  contenido,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionLista({
    required String titulo,
    required IconData icono,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: ColoresApp.primario),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 8),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: Color(0xFF7B5EA7))),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Color(0xFF555555),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
