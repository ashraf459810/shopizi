import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/order.dart';
import 'package:shopizy/services/global_services/order_service.dart';

class OrdersProvider with ChangeNotifier {
  bool loading = true;
  List<Order> orders;
  int page = 1, lastPage = 1;
  ScrollController scrollController = ScrollController();

  OrdersProvider() {
    fetchOrders();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetchMoreOrders();
      }
    });
  }

  fetchOrders() {
    page = 1;
    Get.find<OrderService>().fetchOrdersPage(page).then((value) {
      orders = value.orders;
      loading = false;
      ++page;
      lastPage = value.lastPage;
      notifyListeners();
    });
  }

  fetchMoreOrders() {
    if (page > lastPage) return;
    Get.find<OrderService>().fetchOrdersPage(page).then((value) {
      orders.addAll(value.orders);
      loading = false;
      ++page;
      lastPage = value.lastPage;
      notifyListeners();
    });
  }
}
