/// Adım metnini bir şef eylemine eşler (`assets/images/actions/EYLEM.jpg`).
/// Cümlede birden çok fiil varsa SONUNCUSU asıl iş sayılır ("doğrayıp ... kavurun" → kavur).
/// Hiçbiri eşleşmezse null; ekran o zaman yemeğin görselini gösterir.
const _actions = <String, String>{
  // eylem → Türkçe fiil kökleri (regex). Kök + ek: "kavur(un|up|arak)" gibi.
  'chop': r'doğra|kıy(ın|ıp)|küp (doğra|kes)',
  'slice': r'dilimle|halka',
  'peel': r'\bsoy(un|up|arak)',
  'grate': r'rendele',
  'saute': r'kavur|sotele|mühürle|erit',
  'stir': r'karıştır|çevir',
  'simmer': r'pişir|kaynat',
  'fry': r'kızart',
  'boil': r'haşla',
  'oven': r'fırın',
  'knead': r'yoğur',
  'roll_dough': r'hamuru .*aç|ince aç|açıp|bezelere',
  'wrap': r'\bsar(ın|ıp|arak)\b',
  'stuff': r'doldur|\boy(un|up)\b',
  'whisk': r'çırp|bulamaç|bulay',
  'pour': r'\bdök|gezdir|ekle(yin|yip|yerek)|kat(ın|ıp)\b',
  'wait': r'dinlendir|beklet|mayalan|soğut|demlendir|marine|yumuşat',
  'serve': r'servis|paylaştır|süsle',
  'blend': r'blender|robot',
  'drain': r'\bsüz',
  'roast': r'közle',
  'arrange': r'\bdiz(in|ip|erek)|sırala|\bkoy(un|up)\b|yay(ın|ıp)|sürün',
  'squeeze': r'\bsık(ın|ıp)\b',
  'mash': r'\bez(in|ip|erek)\b|püre|ovun',
};

final _patterns = {for (final e in _actions.entries) e.key: RegExp(e.value, caseSensitive: false)};

String? stepAction(String text) {
  String? best;
  var bestAt = -1;
  for (final e in _patterns.entries) {
    for (final m in e.value.allMatches(text)) {
      if (m.start > bestAt) {
        bestAt = m.start;
        best = e.key;
      }
    }
  }
  return best;
}
