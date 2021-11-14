import 'package:shopizy/models/attribute_option.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class CartItem {
  final int id;
  final int productId;
  final String name;
  final String picturePath;
  final double totalAmount;
  final double amount;
  final int qty;
  final List<AttributeOption> options;
  final String status;
  final int statusId;
  final String features;
  final int discountRate;
  final bool couponDiscountApplied;

  CartItem({
    this.id,
    this.productId,
    this.name,
    this.picturePath,
    this.totalAmount,
    this.qty,
    this.options,
    this.amount,
    this.status,
    this.statusId,
    this.features,
    this.discountRate,
    this.couponDiscountApplied,
  });

  factory CartItem.fromJson(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'],
      productId: data['productId'],
      name: data['name'],
      picturePath: '$cdnBaseUrl/${data['picturePath']}',
      amount: data['amount'].toDouble(),
      totalAmount: data['totalAmount'].toDouble(),
      qty: data['qty'],
      features: data['features'],
      discountRate: data['discountRate'],
      couponDiscountApplied: data['couponDiscountApplied'],
    );
  }

  factory CartItem.fromOrderItemsJson(Map<String, dynamic> data) {
    return CartItem(
      name: data['name'],
      qty: data['qty'],
      options: (data['attributeOptions'] as List).map((e) => AttributeOption.fromOrderItemOptionJson(e)).toList(),
      totalAmount: data['totalAmount'].toDouble(),
      amount: data['amount'].toDouble(),
      id: data['id'],
      picturePath: '$cdnBaseUrl/${data['picturePath']}',
      status: data['statusText'],
      statusId: data['status'],
    );
  }
}
