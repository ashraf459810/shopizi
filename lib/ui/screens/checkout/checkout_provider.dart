import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/models/cart_info.dart';
import 'package:shopizy/models/payment_option.dart';
import 'package:shopizy/models/payment_result.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/ui/screens/payment/payment_provider.dart';
import 'package:shopizy/ui/screens/payment/payment_screen.dart';

import 'checkout_result_screen.dart';

class CheckoutProvider with ChangeNotifier {
  //List<Address> addresses;
  CartInfo get cartInfo => Get.find<CartController>().cartInfo.value;

  Address get selectedAddress => cartInfo.addresses
      .firstWhere((element) => element.isSelected, orElse: () => null);

  bool loading = false, _acceptTermAndConditions = false, doingCheckout = false;

  get acceptTermAndConditions => _acceptTermAndConditions;

  set acceptTermAndConditions(value) {
    _acceptTermAndConditions = value;
    notifyListeners();
  }

  bool get enablePlaceOrder => _acceptTermAndConditions;
  //  &&
  // selectedAddress != null &&
  // _selectedPaymentOption != null;

  selectAddress(Address address) {
    cartInfo.addresses.forEach((element) {
      element.isSelected = false;
    });
    address.isSelected = true;
    notifyListeners();
    Get.back();
  }

  PaymentOption _selectedPaymentOption;

  PaymentOption get selectedPaymentOption => _selectedPaymentOption;

  set selectedPaymentOption(PaymentOption option) {
    _selectedPaymentOption = option;
    notifyListeners();
  }

  fetchAddress() {
    Get.find<CartController>().fetchCart();
  }

  recallcheckout(int addressid, int paymentoptiondid) async {
    try {
      await Get.find<CartController>()
          .recallcheckout(addressid, paymentoptiondid);
    } catch (e) {
      throw e;
    }
  }

  checkout() async {
    try {
      doingCheckout = true;
      notifyListeners();
      await Get.find<CartController>().setCheckoutOptions(
          cartInfo.addresses.firstWhere((element) => element.isSelected).id,
          selectedPaymentOption.id);
      print(selectedPaymentOption.id);

      print(
        cartInfo.addresses.firstWhere((element) => element.isSelected).id,
      );
      PaymentResult result = await Get.find<CartController>().checkout();
      Fluttertoast.showToast(msg: result.message);
      if (result.redirectUrl == null)
        Get.offUntil(
          MaterialPageRoute(builder: (ctx) => CheckoutResultScreen(result)),
          (route) => route.settings.name == '/main',
        );
      else {
        doingCheckout = false;
        notifyListeners();
        Get.to(() => ChangeNotifierProvider(
              create: (ctx) => PaymentProvider(result.redirectUrl),
              child: PaymentScreen(),
            ));
      }
    } catch (ex) {
      doingCheckout = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Checkout failed, Try again later');
    }
  }
}
