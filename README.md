# Easy Purchases
An easy to use package for handling purchases in your flutter app.
Uses the `in_app_purchase` package under the hood.

## Getting started
Install the package by adding it to your `pubspec.yaml` file.

```yaml
dependencies:
  easy_purchases: ^0.0.1
```
Or install it from the command line.
```bash
$ flutter pub add easy_purchases
```

## Usage

### Initialization
```dart
import 'package:easy_purchases/easy_purchases.dart';

// in main.dart
void main() {
  EasyPurchaser.productIds = {'product_id_1', 'product_id_2'};
  runApp(MyApp());
}

// in your widget
final purchaser = EasyPurchaser(
  onPurchaseCompleted: (details) {},
  onPurchaseFailed: (details) {},
  onPurchasePending: (details) {},
  onPurchaseRestored: (details) {},
  onPurchaseCancelled: (details) {},
);
// call this method to initialize the purchaser
await purchaser.init();
```

### Making a purchase
```dart
await purchaser.buyItem('product_id_1');
```