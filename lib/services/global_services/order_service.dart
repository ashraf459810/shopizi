import 'package:get/get.dart';
import 'package:shopizy/models/order_details.dart';
import 'package:shopizy/models/orders_page.dart';
import 'package:shopizy/services/api_services/remote_order_service.dart';

class OrderService {
  Future<OrdersPage> fetchOrdersPage(int page) async {
    try {
      return await Get.find<RemoteOrderService>().fetchOrdersPage(page);
    } catch (ex) {
      throw ex;
    }
  }

  Future<OrderDetails> fetchOrdersDetails(int orderId) async {
    try {
      return await Get.find<RemoteOrderService>().fetchOrdersDetails(orderId);
    } catch (ex) {
      throw ex;
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      return await Get.find<RemoteOrderService>().cancelOrder(orderId);
    } catch (ex) {
      throw ex;
    }
  }

  Future<bool> cancelOrderItem(int orderId, int itemId) async {
    try {
      return await Get.find<RemoteOrderService>().cancelOrderItem(orderId, itemId);
    } catch (ex) {
      throw ex;
    }
  }
}
