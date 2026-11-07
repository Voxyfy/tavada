import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavada/data/pantry.dart';
import 'package:tavada/data/prefs.dart';
import 'package:tavada/data/recipes.dart';
import 'package:tavada/data/saved.dart';
import 'package:tavada/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Varlık okuması testWidgets içinde (sahte zaman) takılıyor; gerçek zamanda, setUpAll'da yüklenir.
  late List<Recipe> recipes;
  setUpAll(() async => recipes = await loadRecipes());

  testWidgets('1 malzeme seçiliyken alt geçiş ve hap görünmez', (tester) async {
    SharedPreferences.setMockInitialValues({
      'prefs.onboarded': true,
      'pantry.selected': ['potato'],
    });
    final prefs = await SharedPreferences.getInstance();
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      TavadaApp(pantry: Pantry(prefs), saved: Saved(prefs), prefs: Prefs(prefs), recipes: recipes),
    );
    await tester.pumpAndSettle();
    for (final k in ['prepare-fade', 'prepare-bar']) {
      expect(tester.widget<AnimatedOpacity>(find.byKey(ValueKey(k))).opacity, 0.0, reason: k);
    }
  });
}
