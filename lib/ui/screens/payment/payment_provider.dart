import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class PaymentProvider with ChangeNotifier {
  String paymentUrl;
  bool loading = true;
  bool pageLoading = true;

  String get successfulPaymentIndicator => '$webBaseUrl/shop/cart/checkout/success/';
  String get failedPaymentIndicator => '$webBaseUrl/shop/cart/checkout?failed=1';

  PaymentProvider(this.paymentUrl);

  showPageLoader() {
    pageLoading = true;
    notifyListeners();
  }

  hidePageLoader() {
    pageLoading = false;
    notifyListeners();
  }
}
