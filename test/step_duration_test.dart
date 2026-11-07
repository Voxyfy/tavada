import 'package:flutter_test/flutter_test.dart';
import 'package:tavada/domain/step_duration.dart';

void main() {
  test('adım metninden süre', () {
    expect(stepDuration('200 °C fırında 35 dakika pişirin.'), const Duration(minutes: 35));
    expect(stepDuration('Her iki tarafını 4\'er dakika kızartın.'), const Duration(minutes: 4));
    expect(stepDuration('3-4 dakika kızartın'), const Duration(minutes: 3));
    expect(stepDuration('kısık ateşte 1 saat pişirin'), const Duration(hours: 1));
    expect(stepDuration('2,5 saat pişirin'), const Duration(minutes: 150));
    expect(stepDuration('10 dk pişirin'), const Duration(minutes: 10));
    expect(stepDuration('Sebzeleri küp doğrayın.'), isNull);
    expect(stepDuration('bir gece bekletin'), isNull);
  });
}
