import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/product_rates.dart';
import 'package:shopizy/models/review.dart';
import 'package:shopizy/models/reviews_page.dart';
import 'package:shopizy/services/global_services/product_service.dart';

class ProductReviewsProvider with ChangeNotifier {
  int productId;
  List<Review> reviews = [];
  bool initialLoading = true, moreLoading = false;
  int page = 1, lastPage = 1;
  ScrollController scrollController = ScrollController();
  ProductRates rates;

  ProductReviewsProvider(this.productId) {
    Get.find<ProductService>().fetchProductRates(productId).then((value) {
      rates = value;
      initialLoading = false;
      Get.find<ProductService>().fetchProductReviewsPage(productId, page).then((reviewPage) {
        reviews.addAll(reviewPage.reviews);
        ++page;
        lastPage = reviewPage.totalPage;
        notifyListeners();
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetchAnotherReviewsPage();
      }
    });
  }

  Future fetchAnotherReviewsPage() async {
    if (page > lastPage) return;
    moreLoading = true;
    notifyListeners();
    ReviewsPage reviewPage = await Get.find<ProductService>().fetchProductReviewsPage(productId, page);
    reviews.addAll(reviewPage.reviews);
    ++page;
    lastPage = reviewPage.totalPage;
    moreLoading = false;
    notifyListeners();
  }
}
