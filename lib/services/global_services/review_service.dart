import 'package:get/get.dart';
import 'package:shopizy/models/product_review.dart';
import 'package:shopizy/models/products_reviews_page.dart';
import 'package:shopizy/services/api_services/remote_reviews_service.dart';

class ReviewService {
  Future<ProductsReviewsPage> fetchWaitingReviewsPage(int page) async {
    try {
      return await Get.find<RemoteReviewsService>().fetchWaitingReviewsPage(page);
    } catch (ex) {
      throw ex;
    }
  }

  Future<ProductsReviewsPage> fetchReviewedProductsPage(int page) async {
    try {
      return await Get.find<RemoteReviewsService>().fetchReviewedProductsPage(page);
    } catch (ex) {
      throw ex;
    }
  }

  Future addReview(ProductReview review) async {
    try {
      return await Get.find<RemoteReviewsService>().addReview(review);
    } catch (ex) {
      throw ex;
    }
  }
}
