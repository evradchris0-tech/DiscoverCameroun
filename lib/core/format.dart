// NOTE : Petits utilitaires de formatage partagés (évite la duplication).

/// Formate un entier avec une espace fine comme séparateur de milliers (ex. 12 000).
String formatThousands(int value) {
  final s = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(s[i]);
  }
  return buffer.toString();
}

/// Formate un prix en FCFA (ex. « 12 000 FCFA »).
String formatFcfa(int value) => '${formatThousands(value)} FCFA';
