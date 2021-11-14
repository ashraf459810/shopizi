import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shopizy/models/add_to_cart_request.dart';
import 'package:shopizy/models/cart_info.dart';
import 'package:shopizy/models/payment_result.dart';
import 'package:shopizy/services/api_services/api_config.dart';
import 'package:shopizy/services/api_services/api_exception.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class RemoteCartService {
  Future<CartInfo> fetchCart() async {
    String url = '$baseUrl/carts';
    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode({}),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        return CartInfo.fromJson(body);
      } else if (response.statusCode == 400) {
        // Empty cart
        return null;
      }
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<CartInfo> setCheckoutOptionWithNoParameters() async {
    String url = '$baseUrl/carts';
    try {
      print(Get.find<UserController>().firebaseToken);
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {'isCartCheckout': true, "checkoutParameters": {}},
        ),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      print('CHECKOUT OPTIONS: ${response.statusCode}');
      if (response.statusCode != 200)
        throw ApiException((json.decode(response.body) as Map)['message']);
      else {
        Map<String, dynamic> body = json.decode(response.body);
        print(response.body);
        return CartInfo.fromJson(body);
      }
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> addToCart(int productId, int quantity,
      List<AttributeSelectedOption> attributesOptions) async {
    String url = '$baseUrl/carts/items';
    AddToCartRequest requestBody = AddToCartRequest(
        productId: productId,
        qty: quantity,
        attributeOptions: attributesOptions);
    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode != 200)
        throw Exception(json.decode(response.body)['message']);
    } catch (ex) {
      print('Exception while adding to cart');
      print(ex);
      throw ex;
    }
  }

  Future updateItemQuantity(int itemId, int quantity) async {
    String url = '$baseUrl/carts/items/$itemId';
    AddToCartRequest requestBody =
        AddToCartRequest(productId: null, qty: quantity, attributeOptions: []);
    try {
      Response response = await http.put(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode == 200)
        return;
      else
        throw ApiException((json.decode(response.body) as Map)['message']);
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future deleteItem(int itemId) async {
    String url = '$baseUrl/carts/items/$itemId';
    try {
      Response response = await http.delete(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode == 200)
        return;
      else
        throw ApiException((json.decode(response.body) as Map)['message']);
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future applyCoupon(String couponCode) async {
    String url = '$baseUrl/carts';
    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode({'couponCode': couponCode}),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode != 200)
        throw ApiException((json.decode(response.body) as Map)['message']);
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future removeCoupon() async {
    String url = '$baseUrl/carts/remove-coupon';
    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode({}),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode != 200)
        throw ApiException((json.decode(response.body) as Map)['message']);
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future setCheckoutOption(int addressId, int paymentOptionId) async {
    String url = '$baseUrl/carts';
    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'isCartCheckout': true,
            'checkoutParameters': {
              'customerAddressId': addressId,
              'paymentOptionId': paymentOptionId,
            }
          },
        ),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      print('CHECKOUT OPTIONS: ${response.statusCode}');
      if (response.statusCode != 200)
        throw ApiException((json.decode(response.body) as Map)['message']);
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<CartInfo> recallcheckout(int addressId, int paymentOptionId) async {
    String url = '$baseUrl/carts';
    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'isCartCheckout': true,
            'checkoutParameters': {
              'customerAddressId': addressId,
              'paymentOptionId': paymentOptionId,
            }
          },
        ),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );

      print('CHECKOUT OPTIONS: ${response.statusCode}');
      if (response.statusCode != 200)
        throw ApiException((json.decode(response.body) as Map)['message']);
      else {
        Map<String, dynamic> body = json.decode(response.body);
        print(response.body);
        print(CartInfo.fromJson(body));
        return CartInfo.fromJson(body);
      }
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<PaymentResult> checkout() async {
    String url = '$baseUrl/checkout';
    try {
      Response response = await http.post(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization':
                  'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return PaymentResult.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
