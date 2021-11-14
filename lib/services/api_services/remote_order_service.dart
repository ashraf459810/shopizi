import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:shopizy/models/order_details.dart';
import 'package:shopizy/models/orders_page.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

import 'api_config.dart';

class RemoteOrderService {
  Future<OrdersPage> fetchOrdersPage(int page) async {
    String url = '$baseUrl/customers/orders-withproducts?page=$page';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return OrdersPage.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<OrderDetails> fetchOrdersDetails(int orderId) async {
    String url = '$baseUrl/customers/orders/$orderId';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return OrderDetails.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    String url = '$baseUrl/customers/orders/$orderId/cancel';
    try {
      Response response = await post(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return response.statusCode == 200;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> cancelOrderItem(int orderId, int itemId) async {
    String url = '$baseUrl/customers/orders/$orderId/$itemId/cancel';
    try {
      Response response = await post(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return response.statusCode == 200;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
