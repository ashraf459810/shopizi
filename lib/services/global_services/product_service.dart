import 'package:get/get.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/models/product_rates.dart';
import 'package:shopizy/models/reviews_page.dart';
import 'package:shopizy/models/search_parameters.dart';
import 'package:shopizy/models/search_response.dart';
import 'package:shopizy/services/api_services/remote_product_service.dart';

class ProductService {
  Future<Product> fetchProductInfo(int productId) async {
    try {
      return await Get.find<RemoteProductService>().fetchProductInfo(productId);
    } catch (ex) {
      throw ex;
    }
  }

  Future<List<Product>> fetchGroupProducts(int productId, String groupKey) async {
    try {
      return await Get.find<RemoteProductService>().fetchGroupProducts(productId, groupKey);
    } catch (ex) {
      throw ex;
    }
  }

  Future<List<Product>> fetchRelatedProducts(int productId) async {
    try {
      return await Get.find<RemoteProductService>().fetchRelatedProducts(productId);
    } catch (ex) {
      throw ex;
    }
  }

  Future<ReviewsPage> fetchProductReviewsPage(int productId, int page) async {
    try {
      return await Get.find<RemoteProductService>().fetchProductReviewsPage(productId, page);
    } catch (ex) {
      throw ex;
    }
  }

  Future<ProductRates> fetchProductRates(int productId) async {
    try {
      return await Get.find<RemoteProductService>().fetchProductRates(productId);
    } catch (ex) {
      throw ex;
    }
  }

  Future<SearchResponse> searchProducts(SearchParameters searchParameters) async {
    try {
      return await Get.find<RemoteProductService>().searchProducts(searchParameters);
    } catch (ex) {
      throw ex;
    }
  }
}
