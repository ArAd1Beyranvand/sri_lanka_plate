/// Province names by plate code.
abstract final class SriLankaRegions {
  static const Map<String, String> _provinces = <String, String>{
    'CP': 'Central Province',
    'EP': 'Eastern Province',
    'NC': 'North Central Province',
    'NP': 'Northern Province',
    'NW': 'North Western Province',
    'SG': 'Sabaragamuwa Province',
    'SP': 'Southern Province',
    'UP': 'Uva Province',
    'WP': 'Western Province',
  };

  /// The province of [code] (one or two letters), or null when it matches no
  /// code or several (`N` and `S` need a second letter).
  static String? lookup(String code) {
    if (code.isEmpty) return null;
    final Set<String> names = <String>{
      for (final MapEntry<String, String> e in _provinces.entries)
        if (e.key.startsWith(code)) e.value,
    };
    return names.length == 1 ? names.single : null;
  }

  static String? captionOf(String Function(String key) group) =>
      lookup(group('province'));
}
