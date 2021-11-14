import 'package:shopizy/models/order.dart';

class OrdersPage {
  final List<Order> orders;
  final int lastPage;

  OrdersPage({this.orders, this.lastPage});

  factory OrdersPage.fromJson(Map<String, dynamic> data) {
    return OrdersPage(
      orders: (data['items'] as List).map((e) => Order.fromJson(e)).toList(),
      lastPage: data['paging']['totalPages'],
    );
  }
}
