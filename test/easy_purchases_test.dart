import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_purchases/easy_purchases.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  test('check availability', () {
    EasyPurchaser.productIds = {'product_id_1', 'product_id_2'};
    final easyPurchases = EasyPurchaser();
    expect(easyPurchases.storeAvailable, false);
  });
}
