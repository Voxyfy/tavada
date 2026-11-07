import 'package:flutter_test/flutter_test.dart';
import 'package:tavada/data/ingredients.dart';
import 'package:tavada/data/prefs.dart';
import 'package:tavada/data/recipes.dart';
import 'package:tavada/domain/matcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<Recipe> recipes;
  setUpAll(() async => recipes = await loadRecipes());

  test('veri seti: kimlikler tekil, her malzeme ve alternatif katalogda', () {
    final ids = ingredients.map((i) => i.id).toSet();
    expect(recipes.length, greaterThanOrEqualTo(150));
    expect(recipes.map((r) => r.id).toSet().length, recipes.length);
    for (final r in recipes) {
      for (final i in r.ingredients) {
        expect(ids, contains(i.id), reason: '${r.id}: ${i.id}');
      }
      for (final e in r.subs.entries) {
        expect(ids, contains(e.value.id), reason: '${r.id}: ${e.key}');
        expect(
          r.ingredients.map((i) => i.id),
          contains(e.key),
          reason: '${r.id}: alternatif tarifte olmayan malzemeye',
        );
      }
      expect(r.steps, isNotEmpty, reason: r.id);
    }
    for (final e in globalSubs.entries) {
      expect(ids, contains(e.key));
      for (final s in e.value) {
        expect(ids, contains(s.id), reason: '${e.key} → ${s.id}');
      }
    }
  });

  test('eşleştirme: eksiksiz önce, alternatifli tek eksik sonra, iki eksik elenir', () {
    final m = matchRecipes(recipes, {'egg', 'pastirma', 'butter'});
    final byId = {for (final x in m) x.recipe.id: x};
    expect(byId['pastirmali_yumurta']!.complete, isTrue);
    final sucuklu = byId['sucuklu_yumurta']!;
    expect(sucuklu.missing.single.id, 'sucuk');
    expect(sucuklu.missing.single.sub!.id, 'pastirma');
    expect(m.indexOf(byId['pastirmali_yumurta']!), lessThan(m.indexOf(sucuklu)));
    // Menemen: yumurta var, domates+biber+tereyağı eksik → listede olmamalı.
    expect(byId.containsKey('menemen'), isFalse);
  });

  test('tarife özel alternatif genel tablonun önüne geçer', () {
    final m = matchRecipes(recipes, {
      'ground_meat',
      'onion',
      'egg',
      'bread',
      'tomato',
      'pepper',
      'tomato_paste',
      'eggplant',
    });
    final izmir = m.firstWhere((x) => x.recipe.id == 'izmir_kofte');
    expect(izmir.missing.single.id, 'potato');
    expect(izmir.missing.single.sub!.note, contains('patlıcan'));
  });

  test('beslenme filtresi: vejetaryen eti, vegan yumurta/süt/balı eler; isteğe bağlı sayılmaz', () {
    final byId = {for (final r in recipes) r.id: r};
    expect(dietAllows(byId['karniyarik']!, Diet.vegetarian), isFalse);
    expect(dietAllows(byId['menemen']!, Diet.vegetarian), isTrue);
    expect(dietAllows(byId['menemen']!, Diet.vegan), isFalse);
    // Zeytinyağlı fasulye: yoğurt yok, vegan uygun.
    expect(dietAllows(byId['zeytinyagli_fasulye']!, Diet.vegan), isTrue);
    // Kıymalı ıspanakta yoğurt isteğe bağlı; vejetaryen yine kıyma yüzünden elenir.
    expect(dietAllows(byId['kiymali_ispanak']!, Diet.vegetarian), isFalse);
    expect(matchRecipes(recipes, {'egg', 'sucuk', 'butter'}, diet: Diet.vegan), isEmpty);
  });
}
