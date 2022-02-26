import 'package:intl/intl.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/models/cart_item.dart';

class OrderDetails {
  final int id;
  final String createdOn;
  final String statusDescription;
  final Address deliveryAddress;
  final double totalDiscountAmount;
  final int cartDiscountRate;
  final double subTotal;
  final double totalShippingAmount;
  final double totalAmount;
  final List<CartItem> orderItems;
  final String cancelReason;
  final int status;
  final String paymentOptionTitle;

  OrderDetails( {
    this.paymentOptionTitle,
    this.id,
    this.createdOn,
    this.statusDescription,
    this.deliveryAddress,
    this.totalDiscountAmount,
    this.cartDiscountRate,
    this.subTotal,
    this.totalShippingAmount,
    this.totalAmount,
    this.orderItems,
    this.cancelReason,
    this.status,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> data) {
    return OrderDetails(
                 paymentOptionTitle : data['paymentOptionTitle'],
   

        id: data['id'],
        createdOn: DateFormat('MMM dd, yyyy').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(data['createdOn'], true)),
        statusDescription: data['statusDescription'],
        deliveryAddress: Address.fromOrderDetailsJson(data['deliveryAddress']),
        totalDiscountAmount: data['subTotalDiscountAmount'].toDouble(),
        cartDiscountRate: data['cartDiscountRate'],
        subTotal: data['subTotal'].toDouble(),
        totalShippingAmount: data['totalShippingAmount'].toDouble(),

        totalAmount: data['totalAmount'].toDouble(),
        orderItems: (data['orderItems'] as List).map((e) => CartItem.fromOrderItemsJson(e)).toList(),
        cancelReason: data['cancelReason'],
        status: data['status']);
  }
}
