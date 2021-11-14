import 'package:shopizy/models/product_review.dart';

class ProductsReviewsPage {
  final List<ProductReview> reviews;
  final int totalPages;

  ProductsReviewsPage({this.reviews, this.totalPages});

  factory ProductsReviewsPage.fromJson(Map<String, dynamic> data) {
    return ProductsReviewsPage(
      reviews: (data['list'] as List).map((e) => ProductReview.fromJson(e)).toList(),
      totalPages: data['totalPages'],
    );
  }
}
