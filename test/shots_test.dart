// Mağaza ekran görüntüleri: ekranları 1206×2622'de (iPhone 6,9") gerçek fontlarla çizer.
// Normal `flutter test`te atlanır; üretmek için:
//   flutter test --dart-define=SHOTS=true --update-goldens test/shots_test.dart
// Çıktı: design/store/NN.png — başlık + yuvarlatılmış telefon ekranı, doğrudan mağazaya yüklenecek boyutta.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavada/data/pantry.dart';
import 'package:tavada/data/prefs.dart';
import 'package:tavada/data/recipes.dart';
import 'package:tavada/data/saved.dart';
import 'package:tavada/domain/matcher.dart';
import 'package:tavada/l10n/app_localizations.dart';
import 'package:tavada/screens/cooking_screen.dart';
import 'package:tavada/screens/home_shell.dart';
import 'package:tavada/screens/recipe_screen.dart';
import 'package:tavada/screens/suggestions_screen.dart';
import 'package:tavada/theme.dart';

const _enabled = bool.fromEnvironment('SHOTS');
const _pantry = [
  'tomato',
  'onion',
  'pepper',
  'eggplant',
  'garlic',
  'ground_meat',
  'egg',
  'yogurt',
  'potato',
  'rice',
  'tomato_paste',
  'sunflower_oil',
  'olive_oil',
  'butter',
  'bread',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<Recipe> recipes;

  setUpAll(() async {
    recipes = await loadRecipes();
    // Gerçek yazı tipleri; yoksa test ortamı kutucuk çizer.
    for (final (family, file) in [('Bricolage', 'BricolageGrotesque.ttf'), ('Inter', 'Inter.ttf')]) {
      final loader = FontLoader(family)..addFont(rootBundle.load('assets/fonts/$file'));
      await loader.load();
    }
  });

  Future<void> shoot(
    WidgetTester tester,
    String name,
    String title,
    String subtitle,
    Widget Function(Pantry, Saved, Prefs) build,
  ) async {
    SharedPreferences.setMockInitialValues({
      'prefs.onboarded': true,
      'pantry.selected': _pantry,
      'saved.recipes': ['karniyarik', 'menemen', 'izmir_kofte', 'ali_nazik', 'sutlac', 'kisir'],
    });
    final prefs = await SharedPreferences.getInstance();
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final pantry = Pantry(prefs);
    final saved = Saved(prefs);
    final p = Prefs(prefs);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        home: _StoreCard(title: title, subtitle: subtitle, child: build(pantry, saved, p)),
      ),
    );
    // Görseller gerçek zamanda çözülür; sahte zamanda beklemek yetmiyor.
    await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 2)));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../design/store/$name.png'));
  }

  testWidgets('shots', skip: !_enabled, (tester) async {
    await shoot(
      tester,
      '01',
      'Evdekiyle\nne pişer?',
      'Mutfağınızdakileri seçin, gerisini Tavada halletsin.',
      (pantry, saved, prefs) => HomeShell(pantry: pantry, saved: saved, prefs: prefs, recipes: recipes),
    );
    await shoot(
      tester,
      '02',
      'Eksik mi var?\nSorun değil.',
      'Yerine ne kullanacağınızı söyleriz.',
      (pantry, saved, prefs) => SuggestionsScreen(
        matches: matchRecipes(recipes, pantry.selected),
        pantry: pantry.selected,
        saved: saved,
        prefs: prefs,
      ),
    );
    final izmir = recipes.firstWhere((r) => r.id == 'izmir_kofte');
    await shoot(
      tester,
      '03',
      '187 Türk yemeği,\nadım adım',
      'Miktarlar kişi sayınıza göre ayarlanır.',
      (pantry, saved, prefs) =>
          RecipeScreen(match: matchOne(izmir, pantry.selected), pantry: pantry.selected, saved: saved, servings: 4),
    );
    await shoot(
      tester,
      '04',
      'Elin hamurdayken\nbile kolay',
      'Büyük yazı, zamanlayıcı, ekran kapanmaz.',
      (pantry, saved, prefs) => CookingScreen(recipe: izmir, saved: saved, startAt: 3),
    );
  });
}

/// Mağaza kartı: krem zemin, başlık, altta telefon oranında (402×874) çizilip ölçeklenmiş ekran.
class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Material olmadan Text sarı alt çizgiyle uyarı verir.
    return Material(
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned(
            left: 32,
            right: 32,
            top: 52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: display(34)),
                const SizedBox(height: 12),
                Text(subtitle, style: body(14, color: AppColors.muted)),
              ],
            ),
          ),
          Positioned(
            left: 28,
            top: 188,
            width: 346,
            height: 760,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.line, width: 2),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  child: SizedBox(width: 402, height: 874, child: child),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
