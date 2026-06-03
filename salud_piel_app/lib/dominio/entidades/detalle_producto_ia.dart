class DetalleProductoIA {
  final String explicacionIngredientes;
  final List<String> beneficios;
  final String idealPara;
  final String? advertencias;
  final double ratingIA;

  DetalleProductoIA({
    required this.explicacionIngredientes,
    required this.beneficios,
    required this.idealPara,
    this.advertencias,
    required this.ratingIA,
  });
}
