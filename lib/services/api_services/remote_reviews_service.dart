import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:shopizy/models/product_review.dart';
import 'package:shopizy/models/products_reviews_page.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

import 'api_config.dart';

class RemoteReviewsService {
  Future<ProductsReviewsPage> fetchWaitingReviewsPage(int page) async {
    String url = '$baseUrl/productreviews/customers-waiting?page=$page&pageSize=10';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return ProductsReviewsPage.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<ProductsReviewsPage> fetchReviewedProductsPage(int page) async {
    String url = '$baseUrl/productreviews/customers?page=$page&pageSize=10';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return ProductsReviewsPage.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future addReview(ProductReview review) async {
    String url = '$baseUrl/productreviews';
    try {
      Response response = await post(
        Uri.parse(url),
        body: json.encode(review),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode != 200) throw Exception('Error posting review');
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
