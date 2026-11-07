import '../data/ingredients.dart';
import '../data/prefs.dart';
import '../data/recipes.dart';

/// Genel alternatif tablosu: eksik malzeme → sırayla denenecek alternatifler.
/// Tarife özel `Recipe.subs` bunun önüne geçer. Notlar kullanıcıya gösterilir.
const globalSubs = <String, List<Substitute>>{
  'butter': [
    Substitute('olive_oil', 'Tereyağı yerine zeytinyağı kullanın.'),
    Substitute('sunflower_oil', 'Tereyağı yerine sıvı yağ kullanın.'),
  ],
  'olive_oil': [
    Substitute('sunflower_oil', 'Zeytinyağı yerine sıvı yağ; tat biraz daha sade olur.'),
    Substitute('butter', 'Zeytinyağı yerine tereyağı kullanın.'),
  ],
  'sunflower_oil': [Substitute('olive_oil', 'Sıvı yağ yerine zeytinyağı kullanın.')],
  'tomato': [
    Substitute('canned_tomato', 'Taze domates yerine konserve domates.'),
    Substitute('tomato_paste', 'Domates yerine 1 yemek kaşığı salçayı az suyla açın.'),
  ],
  'canned_tomato': [Substitute('tomato', 'Konserve yerine rendelenmiş taze domates.')],
  'tomato_paste': [Substitute('pepper_paste', 'Domates salçası yerine biber salçası; biraz daha acı olur.')],
  'pepper_paste': [Substitute('tomato_paste', 'Biber salçası yerine domates salçası ve bir tutam pul biber.')],
  'rice': [Substitute('bulgur', 'Pirinç yerine bulgur; aynı miktarda, aynı sürede.')],
  'bulgur': [Substitute('rice', 'Bulgur yerine pirinç; aynı miktarda.')],
  'feta': [
    Substitute('tulum', 'Beyaz peynir yerine tulum peyniri.'),
    Substitute('kashar', 'Beyaz peynir yerine rendelenmiş kaşar.'),
  ],
  'tulum': [Substitute('feta', 'Tulum yerine beyaz peynir.')],
  'kashar': [Substitute('feta', 'Kaşar yerine beyaz peynir; erimez ama tat verir.')],
  'yogurt': [Substitute('cream_cheese', 'Yoğurt yerine labne.')],
  'cream': [Substitute('milk', 'Krema yerine süt ve 1 yemek kaşığı un.')],
  'kaymak': [Substitute('cream', 'Kaymak yerine krema.'), Substitute('cream_cheese', 'Kaymak yerine labne.')],
  'milk': [Substitute('yogurt', 'Süt yerine suyla açılmış yoğurt.')],
  'lemon': [Substitute('vinegar', 'Limon yerine 1 yemek kaşığı sirke.')],
  'vinegar': [Substitute('lemon', 'Sirke yerine limon suyu.')],
  'honey': [Substitute('molasses', 'Bal yerine pekmez.'), Substitute('sugar', 'Bal yerine şeker; daha az kullanın.')],
  'molasses': [Substitute('honey', 'Pekmez yerine bal.')],
  'pomegranate_syrup': [Substitute('lemon', 'Nar ekşisi yerine biraz daha limon.')],
  'sucuk': [
    Substitute('pastirma', 'Sucuk yerine pastırma; daha kısa pişirin.'),
    Substitute('salami', 'Sucuk yerine salam.'),
  ],
  'pastirma': [Substitute('sucuk', 'Pastırma yerine sucuk.')],
  'spring_onion': [Substitute('onion', 'Taze soğan yerine kuru soğan.')],
  'dill': [Substitute('parsley', 'Dereotu yerine maydanoz.')],
  'parsley': [Substitute('dill', 'Maydanoz yerine dereotu.')],
  'beef_cubes': [
    Substitute('lamb', 'Dana yerine kuzu eti.'),
    Substitute('chicken', 'Et yerine tavuk; pişme süresi yarıya iner.'),
  ],
  'lamb': [Substitute('beef_cubes', 'Kuzu yerine dana kuşbaşı; biraz daha uzun pişirin.')],
  'chicken': [Substitute('beef_cubes', 'Tavuk yerine kuşbaşı et; daha uzun pişirin.')],
  'chard': [Substitute('spinach', 'Pazı yerine ıspanak.')],
  'spinach': [Substitute('chard', 'Ispanak yerine pazı.')],
  'zucchini': [Substitute('eggplant', 'Kabak yerine patlıcan.')],
  'eggplant': [Substitute('zucchini', 'Patlıcan yerine kabak; kızartmadan ekleyin.')],
  'walnut': [Substitute('hazelnut', 'Ceviz yerine fındık.')],
  'hazelnut': [Substitute('walnut', 'Fındık yerine ceviz.')],
  'almond': [Substitute('hazelnut', 'Badem yerine fındık.')],
  'noodles': [Substitute('pasta', 'Erişte yerine makarna.')],
  'pasta': [Substitute('noodles', 'Makarna yerine erişte.')],
  'potato': [Substitute('eggplant', 'Patates yerine patlıcan.')],
  'lavash': [Substitute('phyllo', 'Lavaş yerine yufka.')],
  'bread': [Substitute('lavash', 'Ekmek yerine lavaş.')],
};

/// Eksik bir malzeme ve varsa yerine kullanılabilecek alternatifi.
class Missing {
  const Missing(this.id, this.sub);

  final String id;

  /// Kullanıcının elinde olan alternatif; yoksa null.
  final Substitute? sub;
}

class Match {
  const Match(this.recipe, this.missing);

  final Recipe recipe;

  /// Zorunlu malzemelerden eksik olanlar (en fazla 1).
  final List<Missing> missing;

  bool get complete => missing.isEmpty;

  /// Eksik var ama hepsinin alternatifi elde: tarif yine yapılabilir.
  bool get solvable => missing.every((m) => m.sub != null);
}

/// Elde olan malzemelere göre yapılabilir tarifler: önce eksiksizler, sonra tek eksiği
/// alternatifle kapananlar, sonra tek eksikliler. Birden fazla eksik olanlar elenir.
List<Match> matchRecipes(List<Recipe> recipes, Set<String> pantry, {Diet diet = Diet.all}) {
  final out = <Match>[];
  for (final r in recipes) {
    if (!dietAllows(r, diet)) continue;
    final missing = <Missing>[];
    for (final i in r.ingredients) {
      if (i.optional || pantry.contains(i.id)) continue;
      missing.add(Missing(i.id, _findSub(r, i.id, pantry)));
      if (missing.length > 1) break;
    }
    if (missing.length <= 1) out.add(Match(r, missing));
  }
  int rank(Match m) => m.complete ? 0 : (m.solvable ? 1 : 2);
  out.sort((a, b) {
    final byRank = rank(a).compareTo(rank(b));
    // Eşitlikte daha çok malzemesi eşleşen (daha "tam" hissettiren) tarif üstte.
    return byRank != 0 ? byRank : b.recipe.ingredients.length.compareTo(a.recipe.ingredients.length);
  });
  return out;
}

Substitute? _findSub(Recipe r, String id, Set<String> pantry) {
  final own = r.subs[id];
  if (own != null && pantry.contains(own.id)) return own;
  for (final s in globalSubs[id] ?? const <Substitute>[]) {
    if (pantry.contains(s.id)) return s;
  }
  return null;
}

/// Tek tarif için eşleşme; eksik sayısı sınırlanmaz (Kayıtlılar'dan açılan tarif her durumda gösterilir).
Match matchOne(Recipe r, Set<String> pantry) => Match(r, [
  for (final i in r.ingredients)
    if (!i.optional && !pantry.contains(i.id)) Missing(i.id, _findSub(r, i.id, pantry)),
]);

final _meat = {
  for (final i in ingredients)
    if (i.group == IngredientGroup.meat) i.id,
};
final _animal = {
  ..._meat,
  for (final i in ingredients)
    if (i.group == IngredientGroup.dairy) i.id,
  'honey',
};

/// Beslenme tercihi: zorunlu malzemeler arasında elenen bir şey varsa tarif gösterilmez.
/// İsteğe bağlı malzemeler sayılmaz (kullanıcı atlayabilir).
bool dietAllows(Recipe r, Diet diet) {
  final banned = switch (diet) {
    Diet.all => const <String>{},
    Diet.vegetarian => _meat,
    Diet.vegan => _animal,
  };
  return !r.ingredients.any((i) => !i.optional && banned.contains(i.id));
}
