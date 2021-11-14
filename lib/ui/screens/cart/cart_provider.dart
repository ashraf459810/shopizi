import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/cart_info.dart';
import 'package:shopizy/models/cart_item.dart';
import 'package:shopizy/services/api_services/api_exception.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';

class CartProvider with ChangeNotifier {
  bool loading = true;
  CartInfo get cartInfo => Get.find<CartController>().cartInfo.value;
  TextEditingController couponCodeController = TextEditingController();

  List<CartItem> get items => cartInfo.cartItems;

  fetchCartItems() async {
    await Get.find<CartController>().fetchCart();
    loading = false;
    notifyListeners();
  }

  updateItemQuantity(int itemId, int updatedQuantity) async {
    try {
      await Get.find<CartController>().updateItemQuantity(itemId, updatedQuantity);
      fetchCartItems();
    } catch (ex) {
      if (ex is ApiException) Fluttertoast.showToast(msg: (ex).message);
    }
  }

  deleteItem(int itemId) async {
    try {
      await Get.find<CartController>().deleteItem(itemId);
      fetchCartItems();
    } catch (ex) {
      if (ex is ApiException) Fluttertoast.showToast(msg: ex.message);
    }
  }

  applyCoupon() async {
    try {
      if (couponCodeController.text.isNotEmpty) await Get.find<CartController>().applyCoupon(couponCodeController.text);
      fetchCartItems();
    } catch (ex) {
      if (ex is ApiException) Fluttertoast.showToast(msg: ex.message);
    }
  }

  removeCoupon() async {
    try {
      await Get.find<CartController>().removeCoupon();
      couponCodeController.clear();
      fetchCartItems();
    } catch (ex) {
      if (ex is ApiException) Fluttertoast.showToast(msg: ex.message);
    }
  }
}
