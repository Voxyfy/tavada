import 'package:flutter_test/flutter_test.dart';
import 'package:tavada/data/recipes.dart';
import 'package:tavada/domain/step_action.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fiil → eylem; cümlede son fiil kazanır', () {
    expect(stepAction('Soğanı doğrayıp tereyağında kavurun.'), 'saute');
    expect(stepAction('Patlıcanları közleyip soyun, doğrayın.'), 'chop');
    expect(stepAction('Yapraklara sarıp tencereye dizin.'), 'arrange');
    expect(stepAction('Sarımsaklı yoğurtla karıştırın.'), 'stir');
    expect(stepAction('200 °C fırında 35 dakika pişirin.'), 'simmer');
    expect(stepAction('Hamuru 45 dakika mayalandırın.'), 'wait');
    expect(stepAction('Limon sıkın.'), 'squeeze');
    expect(stepAction('Bir şey.'), isNull);
  });

  test('187 tarifin adımlarının büyük çoğunluğu bir eyleme düşer', () async {
    final recipes = await loadRecipes();
    final steps = [for (final r in recipes) ...r.steps];
    final unmatched = steps.where((s) => stepAction(s) == null).toList();
    // ignore: avoid_print
    print('eşleşmeyen ${unmatched.length}/${steps.length}: $unmatched');
    expect(unmatched.length / steps.length, lessThan(0.05));
  });
}
