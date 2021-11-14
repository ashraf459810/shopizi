import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/product_review.dart';
import 'package:shopizy/models/products_reviews_page.dart';
import 'package:shopizy/services/global_services/review_service.dart';

class ReviewedProductsProvider with ChangeNotifier {
  List<ProductReview> reviews = [];
  bool initialLoading = true, moreLoading = false;
  int page = 1, lastPage = 1;
  ScrollController scrollController = ScrollController();

  ReviewedProductsProvider() {
    Get.find<ReviewService>().fetchReviewedProductsPage(page).then((value) {
      reviews = value.reviews;
      initialLoading = false;
      ++page;
      lastPage = value.totalPages;
      notifyListeners();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetchAnotherReviewsPage();
      }
    });
  }

  reload() {
    page = lastPage = 1;
    Get.find<ReviewService>().fetchReviewedProductsPage(page).then((value) {
      reviews = value.reviews;
      initialLoading = false;
      ++page;
      lastPage = value.totalPages;
      notifyListeners();
    });
  }

  Future fetchAnotherReviewsPage() async {
    if (page > lastPage) return;
    moreLoading = true;
    notifyListeners();
    ProductsReviewsPage reviewPage = await Get.find<ReviewService>().fetchReviewedProductsPage(page);
    reviews.addAll(reviewPage.reviews);
    ++page;
    lastPage = reviewPage.totalPages;
    moreLoading = false;
    notifyListeners();
  }
}
