/// Adım metninden pişirme süresini çıkarır: "35 dakika", "3-4 dakika" (ilki), "1 saat", "2,5 saat".
/// Süre yoksa null. "Bir gece bekletin" gibi ifadeler bilerek kapsam dışı.
Duration? stepDuration(String text) {
  final m = RegExp(
    r"(\d+(?:[,.]\d+)?)\s*(?:-\s*\d+\s*)?('?er\s+)?(dakika|dk|saat)",
    caseSensitive: false,
  ).firstMatch(text);
  if (m == null) return null;
  final value = double.parse(m.group(1)!.replaceAll(',', '.'));
  final minutes = m.group(3)!.toLowerCase() == 'saat' ? value * 60 : value;
  return Duration(seconds: (minutes * 60).round());
}
