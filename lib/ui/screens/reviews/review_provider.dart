import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/product_review.dart';
import 'package:shopizy/services/global_services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  ProductReview review;
  TextEditingController reviewController = TextEditingController();
  bool posting = false;

  ReviewProvider(this.review) {
    if (review.review?.isNotEmpty ?? false) reviewController.text = review.review;
  }

  addReview() async {
    if (reviewController.text.isEmpty) return;
    try {
      posting = true;
      notifyListeners();
      review.review = reviewController.text;
      await Get.find<ReviewService>().addReview(review);
      Get.back(result: true);
    } catch (ex) {
      Fluttertoast.showToast(msg: ex);
      posting = false;
      notifyListeners();
    }
  }
}
