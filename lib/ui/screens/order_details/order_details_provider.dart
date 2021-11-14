import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/order_details.dart';
import 'package:shopizy/services/global_services/order_service.dart';

class OrderDetailsProvider with ChangeNotifier {
  bool loading = true, cancelling = false;
  int cancellingItemId;
  OrderDetails orderDetails;
  int orderId;

  OrderDetailsProvider(this.orderId) {
    fetchOrderDetails();
  }

  fetchOrderDetails() async {
    orderDetails = await Get.find<OrderService>().fetchOrdersDetails(orderId);
    loading = false;
    notifyListeners();
  }

  cancelOrder(BuildContext ctx) async {
    cancelling = true;
    notifyListeners();
    bool isSuccessful = await Get.find<OrderService>().cancelOrder(orderId);
    if (isSuccessful) {
      await fetchOrderDetails();
      Fluttertoast.showToast(msg: FlutterI18n.translate(ctx, 'ordercancelled'));
    }
    cancelling = false;
    Get.back(result: true);
  }

  cancelOrderItem(BuildContext ctx, int itemId) async {
    cancellingItemId = itemId;
    notifyListeners();
    bool isSuccessful = await Get.find<OrderService>().cancelOrderItem(orderId, itemId);
    if (isSuccessful) {
      await fetchOrderDetails();
      Fluttertoast.showToast(msg: FlutterI18n.translate(ctx, 'orderitemcancelled'));
    }
    cancellingItemId = null;
    Get.back(result: true);
  }
}
