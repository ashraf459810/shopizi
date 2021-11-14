import 'package:get/get.dart';
import 'package:shopizy/models/add_to_cart_request.dart';
import 'package:shopizy/models/cart_info.dart';
import 'package:shopizy/models/payment_result.dart';
import 'package:shopizy/services/api_services/remote_cart_service.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class CartController extends GetxController {
  final cartInfo = CartInfo().obs;
  final initialLoading = false.obs;

  static CartController get instance => Get.find<CartController>();

  Future fetchCart() async {
    try {
      initialLoading(true);
      cartInfo(await Get.find<RemoteCartService>().fetchCart());
      initialLoading(false);
    } catch (ex) {
      throw ex;
    }
  }

  Future addToCart(int productId, int quantity,
      List<AttributeSelectedOption> attributesOptions) async {
    UserController userService = Get.find<UserController>();
    try {
      if (!userService.isAuthenticated) await userService.signInAnonymously();
      await Get.find<RemoteCartService>()
          .addToCart(productId, quantity, attributesOptions);
      await fetchCart();
    } catch (ex) {
      throw ex;
    }
  }

  Future updateItemQuantity(int itemId, int quantity) async {
    try {
      return await Get.find<RemoteCartService>()
          .updateItemQuantity(itemId, quantity);
    } catch (ex) {
      throw ex;
    }
  }

  Future<CartInfo> setCheckoutOptionswithNoParameters() async {
    try {
      return await Get.find<RemoteCartService>()
          .setCheckoutOptionWithNoParameters();
    } catch (ex) {
      throw ex;
    }
  }

  Future deleteItem(int itemId) async {
    try {
      return await Get.find<RemoteCartService>().deleteItem(itemId);
    } catch (ex) {
      throw ex;
    }
  }

  Future applyCoupon(String couponCode) async {
    try {
      return await Get.find<RemoteCartService>().applyCoupon(couponCode);
    } catch (ex) {
      throw ex;
    }
  }

  Future removeCoupon() async {
    try {
      return await Get.find<RemoteCartService>().removeCoupon();
    } catch (ex) {
      throw ex;
    }
  }

  Future setCheckoutOptions(int addressId, int paymentOptionId) async {
    try {
      return await Get.find<RemoteCartService>()
          .setCheckoutOption(addressId, paymentOptionId);
    } catch (ex) {
      throw ex;
    }
  }

  Future<CartInfo> recallcheckout(int addressId, int paymentOptionId) async {
    try {
      return await Get.find<RemoteCartService>()
          .recallcheckout(addressId, paymentOptionId);
    } catch (ex) {
      throw ex;
    }
  }

  Future<PaymentResult> checkout() async {
    try {
      PaymentResult result = await Get.find<RemoteCartService>().checkout();
      if (result.redirectUrl == null) cartInfo(CartInfo());
      return result;
    } catch (ex) {
      throw ex;
    }
  }

  clear() {
    cartInfo(CartInfo());
  }
}
