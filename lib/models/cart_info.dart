import 'package:shopizy/models/cart_item.dart';
import 'package:shopizy/models/payment_option.dart';

import 'address.dart';

class CartInfo {
  final int id;
  final double finalSubTotalAmount;
  final double finalShippingAmount;
  final double finalTotalAmount;
  final int totalDiscountRate;
  final double totalAmount;
  final List<CartItem> cartItems;
  final String couponCode;
  final List<PaymentOption> paymentOptions;
  final int totalQty;
  final List<Address> addresses;
  final bool isSelected;

  CartInfo(
      {this.id,
      this.finalSubTotalAmount,
      this.finalShippingAmount,
      this.finalTotalAmount,
      this.totalDiscountRate,
      this.totalAmount,
      this.cartItems,
      this.couponCode,
      this.paymentOptions,
      this.totalQty,
      this.addresses,
      this.isSelected});

  factory CartInfo.fromJson(Map<String, dynamic> data) => CartInfo(
        id: data['id'],
        finalSubTotalAmount: data['finalSubTotalAmount'].toDouble(),
        finalShippingAmount: data['finalShippingAmount'].toDouble(),
        finalTotalAmount: data['finalTotalAmount'].toDouble(),
        totalDiscountRate: data['totalDiscountRate'],
        totalAmount: data['totalAmount'].toDouble(),
        cartItems: (data['cartItems'] as List)
            .map((e) => CartItem.fromJson(e))
            .toList(),
        couponCode: data['couponCode'],
        paymentOptions: (data['paymentOptions'] as List)
            .map((e) => PaymentOption.fromJson(e))
            .toList(),
        totalQty: data['totalQty'],
        addresses: data['customerAddressList'] != null
            ? (data['customerAddressList'] as List)
                .map((e) => Address.fromJson(e))
                .toList()
            : [],
      );
}
