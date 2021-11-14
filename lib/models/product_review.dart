import 'package:intl/intl.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class ProductReview {
  final int orderId;
  final int productId;
  final String productName;
  final String productImage;
  final String createdOn;
  final String deliveryDate;
  final int qty;
  final int orderItemId;

  final int id;
  final String reviewStatus;
  final int status;
  final String rejectReason;
  String review;
  int rate;

  ProductReview({
    this.orderId,
    this.productId,
    this.productName,
    this.productImage,
    this.createdOn,
    this.deliveryDate,
    this.qty,
    this.orderItemId,
    this.id,
    this.reviewStatus,
    this.status,
    this.rejectReason,
    this.review,
    this.rate,
  });

  factory ProductReview.fromJson(Map<String, dynamic> data) {
    return ProductReview(
      orderId: data['orderId'],
      productId: data['productId'],
      productName: data['productName'],
      productImage: '$cdnBaseUrl/${data['productImage']}',
      createdOn: DateFormat('MMM dd, yyyy').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(data['createdOn'], true)),
      deliveryDate: data['deliveryDate'] != null
          ? DateFormat('MMM dd, yyyy').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(data['deliveryDate'], true))
          : null,
      qty: data['qty'],
      orderItemId: data['orderItemId'],
      id: data['id'],
      reviewStatus: data['reviewStatus'],
      status: data['status'],
      rejectReason: data['rejectReason'],
      review: data['review'],
      rate: data['rate'],
    );
  }

  Map<String, dynamic> toJson() => orderItemId != null
      ? {
          'productId': productId,
          'rate': rate,
          'review': review,
          'orderItemId': orderItemId,
        }
      : {
          'productId': productId,
          'rate': rate,
          'review': review,
        };
}
