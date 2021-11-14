import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/cart_info.dart';
import 'package:shopizy/models/payment_result.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/ui/screens/checkout/checkout_result_screen.dart';
import 'package:shopizy/ui/screens/payment/payment_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentProvider provider;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<PaymentProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: WebView(
            initialUrl: provider.paymentUrl,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains(provider.successfulPaymentIndicator)) {
                int orderId = int.parse(request.url.substring(request.url.lastIndexOf('/') + 1));
                Get.find<CartController>().cartInfo(CartInfo());
                Get.offUntil(MaterialPageRoute(builder: (ctx) => CheckoutResultScreen(PaymentResult(orderId: orderId))),
                    (route) => route.settings.name == '/main');
                return null;
              } else if (request.url.contains(provider.failedPaymentIndicator)) {
                Fluttertoast.showToast(msg: 'Payment Failed');
                Get.back();
                return null;
              }
              return NavigationDecision.navigate;
            }),
      ),
    );
  }
}
