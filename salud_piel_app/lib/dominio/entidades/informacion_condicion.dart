class InformacionCondicion {
  final String descripcion;
  final List<String> causas;
  final String? recomendacionDermatologo;
  final List<String> consejosCuidado;

  InformacionCondicion({
    required this.descripcion,
    required this.causas,
    this.recomendacionDermatologo,
    required this.consejosCuidado,
  });
}
