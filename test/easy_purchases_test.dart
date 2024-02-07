import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_purchases/easy_purchases.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // set product ids
  EasyPurchaser.productIds = {'product_id_1', 'product_id_2'};

  test('check availability', () async {
    final easyPurchases = EasyPurchaser();
    await easyPurchases.init();
    expect(easyPurchases.storeAvailable, false);
  });
}
