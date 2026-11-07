import 'package:flutter_test/flutter_test.dart';
import 'package:tavada/domain/scale_qty.dart';

void main() {
  test('miktar ölçekleme', () {
    expect(scaleQty('500 g', 0.5), '250 g');
    expect(scaleQty('4 adet', 0.5), '2 adet');
    expect(scaleQty('1,5 su bardağı', 2), '3 su bardağı');
    expect(scaleQty('1/2 su bardağı', 2), '1 su bardağı');
    expect(scaleQty('2 yemek kaşığı', 1.25), '2,5 yemek kaşığı');
    expect(scaleQty('3 adet', 0.5), '1,5 adet');
    expect(scaleQty('1 adet', 0.25), '0,25 adet');
    expect(scaleQty('yarım demet', 2), 'yarım demet');
    expect(scaleQty('kızartmak için', 0.5), 'kızartmak için');
    expect(scaleQty('500 g', 1), '500 g');
    expect(scaleQty('200 °C', 2), '400 °C'); // sıcaklık miktar listesinde geçmez; adımlar ölçeklenmez
  });
}
