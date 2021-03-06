import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/product_review.dart';
import 'package:shopizy/models/products_reviews_page.dart';
import 'package:shopizy/services/global_services/review_service.dart';

class WaitingReviewsProvider with ChangeNotifier {
  List<ProductReview> reviews = [];
  bool initialLoading = true, moreLoading = false;
  int page = 1, lastPage = 1;
  ScrollController scrollController = ScrollController();

  WaitingReviewsProvider() {
    Get.find<ReviewService>().fetchWaitingReviewsPage(page).then((value) {
      log("here at the brgining");
      reviews = value.reviews;
      initialLoading = false;
      ++page;
      lastPage = value.totalPages;
      notifyListeners();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        log("here");
        fetchAnotherReviewsPage();
      }
    });
  }

  reload() {
    page = lastPage = 1;
    Get.find<ReviewService>().fetchWaitingReviewsPage(page).then((value) {
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
    ProductsReviewsPage reviewPage =
        await Get.find<ReviewService>().fetchWaitingReviewsPage(page);
    reviews.addAll(reviewPage.reviews);
    ++page;
    lastPage = reviewPage.totalPages;
    moreLoading = false;

    notifyListeners();
  }
}
