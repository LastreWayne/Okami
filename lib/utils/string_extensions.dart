
//Extension para capitalizar un str
extension StringCasing on String {
  String get capitalized => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}