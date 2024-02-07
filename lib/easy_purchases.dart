library easy_purchases;

import 'dart:async';
import 'dart:developer';

import 'package:in_app_purchase/in_app_purchase.dart';

class EasyPurchaser {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription _subscription;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  bool storeAvailable = false;
  static Set<String> productIds = {};

  // class properties
  final Function(PurchaseDetails)? onPurchaseCompleted;
  final Function(PurchaseDetails)? onPurchaseError;
  final Function(PurchaseDetails)? onPurchasePending;
  final Function(PurchaseDetails)? onPurchaseCancelled;
  final Function(PurchaseDetails)? onPurchaseRestored;

  EasyPurchaser({
    this.onPurchaseCompleted,
    this.onPurchaseError,
    this.onPurchasePending,
    this.onPurchaseCancelled,
    this.onPurchaseRestored,
  });

  Future<void> init() async {
    log('initializing easy purchases');

    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      storeAvailable = false;
      return;
    }
    storeAvailable = true;

    await _getProducts();

    _subscription = _inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // handle error here.
        log(error.toString());
      },
    );
  }

  Future<void> _getProducts() async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);
    products = response.productDetails;
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      // handle purchase here.
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        log('purchase completed');
        await onPurchaseCompleted?.call(purchaseDetails);
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
      // handle cancelled purchase here.
      else if (purchaseDetails.status == PurchaseStatus.canceled) {
        log('purchase cancelled');
        await onPurchaseCancelled?.call(purchaseDetails);
      }
      // handle pending purchase here.
      else if (purchaseDetails.status == PurchaseStatus.pending) {
        log('purchase pending');
        await onPurchasePending?.call(purchaseDetails);
      }
      // handle restored purchase here.
      else if (purchaseDetails.status == PurchaseStatus.restored) {
        log('purchase restored');
        purchases.add(purchaseDetails);
        await onPurchaseRestored?.call(purchaseDetails);
      }
      // handle error here.
      else if (purchaseDetails.status == PurchaseStatus.error) {
        log('purchase error');
        await onPurchaseError?.call(purchaseDetails);
      }
    }
  }

  Future<bool> buyItem(String itemId, {bool? consumable}) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: products.firstWhere((element) => element.id == itemId),
    );

    if (consumable == true) {
      return await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
    return await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<bool> buySubscription(String itemId) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: products.firstWhere((element) => element.id == itemId),
    );
    return await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    purchases = [];
    await _inAppPurchase.restorePurchases();
    await Future.delayed(const Duration(seconds: 2));
  }

  void dispose() {
    _subscription.cancel();
  }
}
