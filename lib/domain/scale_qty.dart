/// Miktar metnini kişi sayısına göre ölçekler: "500 g" ×0,5 → "250 g", "1,5 su bardağı" ×2 → "3 su bardağı".
/// Başta sayı yoksa ("yarım demet", "kızartmak için", "servis için") metin olduğu gibi kalır.
/// Kesirler desteklenir: "1/2 su bardağı" ×2 → "1 su bardağı". Çarpan 1 ise dokunulmaz.
String scaleQty(String qty, double factor) {
  if (factor == 1) return qty;
  final m = RegExp(r'^(\d+)(?:[,.](\d+))?(?:/(\d+))?(.*)$').firstMatch(qty.trim());
  if (m == null) return qty;
  final whole = double.parse(m.group(1)!);
  final value = m.group(3) != null
      ? whole / double.parse(m.group(3)!)
      : m.group(2) != null
      ? double.parse('${m.group(1)}.${m.group(2)}')
      : whole;
  return '${_format(value * factor)}${m.group(4)}';
}

/// 0,25'e yuvarlar; tam sayıysa ondalık göstermez, Türkçe virgül kullanır.
String _format(double v) {
  final r = (v * 4).round() / 4;
  if (r == r.roundToDouble()) return r.toInt().toString();
  // Bir avuç özel durum: 0,5 ve 0,25 mutfakta "yarım", "çeyrek" diye okunur ama birimler değişken;
  // sayı olarak bırakmak her birimle uyumlu.
  return r.toString().replaceAll('.', ',').replaceAll(RegExp(r',?0+$'), '');
}
