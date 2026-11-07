import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavada/data/ingredients.dart';
import 'package:tavada/data/pantry.dart';
import 'package:tavada/data/prefs.dart';
import 'package:tavada/data/recipes.dart';
import 'package:tavada/data/saved.dart';
import 'package:tavada/main.dart';
import 'package:tavada/screens/kitchen_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<Recipe> recipes;
  setUpAll(() async => recipes = await loadRecipes());

  test('Türkçe harf katlama: İ/I doğru küçülür', () {
    expect(foldTurkish('IŞIK'), 'ışık');
    expect(foldTurkish('İzmir'), 'izmir');
    expect(foldTurkish('Patlıcan').contains(foldTurkish('PATLI')), isTrue);
  });

  test('Katalogda kimlikler tekil', () {
    expect(ingredients.map((i) => i.id).toSet().length, ingredients.length);
  });

  test('Seçim kalıcı: yeni Pantry aynı listeyi okur', () async {
    SharedPreferences.setMockInitialValues({'prefs.onboarded': true});
    final prefs = await SharedPreferences.getInstance();
    Pantry(prefs).toggle('egg');
    expect(Pantry(prefs).has('egg'), isTrue);
  });

  testWidgets('Çipe dokununca sayaç artar, arama süzer', (tester) async {
    SharedPreferences.setMockInitialValues({'prefs.onboarded': true});
    final pantry = Pantry(await SharedPreferences.getInstance());
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      TavadaApp(
        pantry: pantry,
        saved: Saved(await SharedPreferences.getInstance()),
        prefs: Prefs(await SharedPreferences.getInstance()),
        recipes: recipes,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Domates'));
    await tester.pump();
    // 3 malzemeden azken Hazırla hapı görünmez.
    expect(find.text('1 malzeme').hitTestable(), findsNothing);
    await tester.tap(find.text('Soğan'));
    await tester.tap(find.text('Biber'));
    await tester.pumpAndSettle();
    expect(find.text('3 malzeme'), findsOneWidget);

    // Önizlemede 8 çip + "+18 daha"; grupta 26 sebze var.
    expect(find.text('Salatalık'), findsNothing);
    expect(find.text('+18 daha'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'patl');
    await tester.pump();
    expect(find.text('Patlıcan'), findsOneWidget);
    expect(find.text('Soğan'), findsNothing);
  });

  testWidgets('"+N daha" alttan sayfa açar, oradan seçim kalıcı olur', (tester) async {
    SharedPreferences.setMockInitialValues({'prefs.onboarded': true});
    final pantry = Pantry(await SharedPreferences.getInstance());
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      TavadaApp(
        pantry: pantry,
        saved: Saved(await SharedPreferences.getInstance()),
        prefs: Prefs(await SharedPreferences.getInstance()),
        recipes: recipes,
      ),
    );
    await tester.pumpAndSettle();

    // Çip alt kart ve menünün altında kalıyor; önce yukarı kaydır.
    await tester.drag(find.byType(CustomScrollView).first, const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+18 daha'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pırasa'));
    await tester.pump();
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(pantry.has('leek'), isTrue);
  });

  testWidgets('Hazırla → Öneriler: başlık sayıları ve Eksiksiz filtresi', (tester) async {
    SharedPreferences.setMockInitialValues({
      'prefs.onboarded': true,
      'pantry.selected': ['egg', 'pastirma', 'butter'],
    });
    final pantry = Pantry(await SharedPreferences.getInstance());
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      TavadaApp(
        pantry: pantry,
        saved: Saved(await SharedPreferences.getInstance()),
        prefs: Prefs(await SharedPreferences.getInstance()),
        recipes: recipes,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hazırla'));
    await tester.pumpAndSettle();
    expect(find.textContaining('3 malzemeden'), findsOneWidget);
    expect(find.text('Pastırmalı Yumurta'), findsOneWidget);
    expect(find.text('Sucuk yerine Pastırma'), findsOneWidget);

    await tester.tap(find.text('Eksiksiz'));
    await tester.pumpAndSettle();
    expect(find.text('Sucuklu Yumurta'), findsNothing);
    expect(find.text('Pastırmalı Yumurta'), findsOneWidget);
  });

  testWidgets('Karta dokununca tarif açılır: eksik kutusu, ölçekli miktar ve adımlar', (tester) async {
    SharedPreferences.setMockInitialValues({
      'prefs.onboarded': true,
      'prefs.servings': 4,
      'pantry.selected': ['egg', 'pastirma', 'butter'],
    });
    final pantry = Pantry(await SharedPreferences.getInstance());
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      TavadaApp(
        pantry: pantry,
        saved: Saved(await SharedPreferences.getInstance()),
        prefs: Prefs(await SharedPreferences.getInstance()),
        recipes: recipes,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hazırla'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sucuklu Yumurta'));
    await tester.pumpAndSettle();
    expect(find.text('Sucuk → Pastırma'), findsOneWidget);
    // Tarif 2 kişilik, ayar 4 kişi → yumurta 4 adet ×2.
    expect(find.text('8 adet'), findsOneWidget);
    // Tarife özel not genel tablonun önüne geçer.
    expect(find.textContaining('1 dakika yeter'), findsOneWidget);

    await tester.tap(find.textContaining('Yapılışı'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sucuğu dilimleyip'), findsOneWidget);
  });

  testWidgets('Pişirme modu: adımlar ilerler, süreli adımda zamanlayıcı', (tester) async {
    SharedPreferences.setMockInitialValues({
      'prefs.onboarded': true,
      'pantry.selected': ['egg', 'sucuk', 'butter'],
    });
    final pantry = Pantry(await SharedPreferences.getInstance());
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      TavadaApp(
        pantry: pantry,
        saved: Saved(await SharedPreferences.getInstance()),
        prefs: Prefs(await SharedPreferences.getInstance()),
        recipes: recipes,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hazırla'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sucuklu Yumurta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pişirmeye başla'));
    await tester.pumpAndSettle();

    expect(find.text('Adım 1 / 2'), findsOneWidget);
    expect(find.text('Önceki'), findsNothing);
    await tester.tap(find.text('Sonraki'));
    await tester.pumpAndSettle();
    expect(find.text('Adım 2 / 2'), findsOneWidget);
    // "kapağı kapatıp 3 dakika pişirin" → 03:00
    expect(find.text('03:00'), findsOneWidget);
    await tester.tap(find.text('Başlat'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('02:58'), findsOneWidget);
    await tester.tap(find.text('Duraklat'));
    await tester.pump();
    await tester.tap(find.text('Bitti, afiyet olsun'));
    await tester.pumpAndSettle();
    expect(find.text('Afiyet olsun!'), findsOneWidget);
    await tester.tap(find.text('Kaydet'));
    await tester.pump();
    expect(find.text('Kaydedildi'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getStringList('saved.recipes'), ['sucuklu_yumurta']);
  });

  testWidgets('Kayıtlılar sekmesi: boş durum, sonra kaydedilen tarif kartı ve açılışı', (tester) async {
    SharedPreferences.setMockInitialValues({'prefs.onboarded': true, 'pantry.selected': <String>[]});
    final prefs = await SharedPreferences.getInstance();
    final saved = Saved(prefs);
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(TavadaApp(pantry: Pantry(prefs), saved: saved, prefs: Prefs(prefs), recipes: recipes));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kayıtlılar'));
    await tester.pumpAndSettle();
    expect(find.text('Kaydettiğiniz tarifler burada görünür'), findsOneWidget);

    saved.toggle('menemen');
    await tester.pumpAndSettle();
    expect(find.text('Menemen'), findsOneWidget);
    expect(find.text('15 dk'), findsOneWidget);

    // Dolap boşken bile kayıtlı tarif açılır; eksikler sarı kutuda listelenir.
    await tester.tap(find.text('Menemen'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Yumurta eksik'), findsOneWidget);
  });

  testWidgets('Ayarlar: vejetaryen seçince etli tarifler önerilerden düşer, dil değişir', (tester) async {
    SharedPreferences.setMockInitialValues({
      'prefs.onboarded': true,
      'pantry.selected': ['egg', 'sucuk', 'butter'],
    });
    final prefs = await SharedPreferences.getInstance();
    final p = Prefs(prefs);
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(TavadaApp(pantry: Pantry(prefs), saved: Saved(prefs), prefs: p, recipes: recipes));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ayarlar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beslenme tercihi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vejetaryen'));
    await tester.pumpAndSettle();
    expect(p.diet, Diet.vegetarian);
    expect(prefs.getString('prefs.diet'), 'vegetarian');

    await tester.tap(find.text('Mutfağım'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hazırla'));
    await tester.pumpAndSettle();
    expect(find.text('Sucuklu Yumurta'), findsNothing);
    // Liste tembel kurulduğu için belirli bir kartı değil, sonuç olduğunu doğrula.
    expect(find.textContaining('yemek çıktı'), findsOneWidget);

    p.localeCode = 'en';
    await tester.pumpAndSettle();
    expect(find.text('Complete'), findsOneWidget);
  });

  testWidgets('İlk açılış: tanıtım 3 sayfa, tercih seçimi, sonra ana ekran', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final p = Prefs(prefs);
    tester.platformDispatcher.localesTestValue = [const Locale('tr')];
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(TavadaApp(pantry: Pantry(prefs), saved: Saved(prefs), prefs: p, recipes: recipes));
    await tester.pumpAndSettle();

    expect(find.text('Evdekiyle ne pişer?'), findsOneWidget);
    await tester.tap(find.text('Başlayalım'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Devam'));
    await tester.pumpAndSettle();
    expect(find.text('Sizi biraz tanıyalım'), findsOneWidget);
    await tester.tap(find.text('Vejetaryen'));
    await tester.pump();
    await tester.tap(find.text('Mutfağıma geç'));
    await tester.pumpAndSettle();

    expect(p.onboarded, isTrue);
    expect(p.diet, Diet.vegetarian);
    expect(prefs.getBool('prefs.onboarded'), isTrue);
    expect(find.text('Mutfağınızda\nne var?'), findsOneWidget);
  });
}
