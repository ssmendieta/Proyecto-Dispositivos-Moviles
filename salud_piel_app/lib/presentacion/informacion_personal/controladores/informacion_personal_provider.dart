import 'package:flutter_riverpod/flutter_riverpod.dart';

final tipoPielInformacionProvider = StateProvider<String>((ref) {
  return 'Grasa';
});

final cargandoInformacionPersonalProvider = StateProvider<bool>((ref) {
  return false;
});

final tiposPielInformacionProvider = Provider<List<String>>((ref) {
  return const [
    'Grasa',
    'Seca',
    'Mixta',
    'Sensible',
    'Normal',
  ];
});