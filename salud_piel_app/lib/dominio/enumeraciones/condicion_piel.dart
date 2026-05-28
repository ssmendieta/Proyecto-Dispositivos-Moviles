enum CondicionPiel {
  acne,
  eczema,
  rosacea,
  melasma,
  psoriasis,
  dermatitis,
  normal,
  otro,
}

extension CondicionPielExtension on CondicionPiel {
  String get displayName {
    switch (this) {
      case CondicionPiel.acne:
        return 'Acné';
      case CondicionPiel.eczema:
        return 'Eczema';
      case CondicionPiel.rosacea:
        return 'Rosácea';
      case CondicionPiel.melasma:
        return 'Melasma';
      case CondicionPiel.psoriasis:
        return 'Psoriasis';
      case CondicionPiel.dermatitis:
        return 'Dermatitis Atópica';
      case CondicionPiel.normal:
        return 'Piel Normal';
      case CondicionPiel.otro:
        return 'Otra Condición';
    }
  }
}
