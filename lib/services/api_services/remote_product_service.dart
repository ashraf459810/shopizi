import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/models/product_rates.dart';
import 'package:shopizy/models/reviews_page.dart';
import 'package:shopizy/models/search_parameters.dart';
import 'package:shopizy/models/search_response.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class RemoteProductService {
  Future<Product> fetchProductInfo(int productId) async {
    String url = '$baseUrl/products/$productId';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return Product.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<List<Product>> fetchGroupProducts(int productId, String groupKey) async {
    String url = '$baseUrl/products/$productId/$groupKey/groupproducts';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return (json.decode(response.body) as List).map((e) => Product.fromJson(e)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<List<Product>> fetchRelatedProducts(int productId) async {
    String url = '$baseUrl/products/$productId/relatedproducts';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return (json.decode(response.body) as List).map((e) => Product.fromJson(e)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<ReviewsPage> fetchProductReviewsPage(int productId, int page) async {
    String url = '$baseUrl/productreviews/all/$productId?page=$page&pageSize=10';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return ReviewsPage.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<ProductRates> fetchProductRates(int productId) async {
    String url = '$baseUrl/productreviews/rates/$productId';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return ProductRates.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<SearchResponse> searchProducts(SearchParameters searchParameters) async {
    print('Search Parameters: ${searchParameters.toString()}');
    String url = '$baseUrl/products/searchweb';
    try {
      Response response = await http.post(Uri.parse(url),
          body: json.encode(searchParameters), headers: generalHeaders..addAll({'Content-Type': 'application/json'}));
      print('Search products response: ${response.body}');
      return SearchResponse.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
