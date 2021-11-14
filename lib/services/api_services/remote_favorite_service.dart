import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:shopizy/models/favorites_page.dart';
import 'package:shopizy/services/api_services/api_config.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class RemoteFavoriteService {
  Future<bool> isFavorite(int productId) async {
    String url = '$baseUrl/favoriteproducts/$productId';
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
      return response.statusCode == 200 && json.decode(response.body)['isFavorite'];
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future toggleFavorite(int productId, {bool addToFavorite = false}) async {
    String url = addToFavorite == false ? '$baseUrl/favoriteproducts/$productId' : '$baseUrl/favoriteproducts/$productId?add=1';
    try {
      Response response = await post(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode != 200) throw Exception();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<FavoritesPage> fetchFavoritesPage({int page}) async {
    String url = '$baseUrl/favoriteproducts/customer?page=$page';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Connection': 'Keep-Alive',
              'Keep-Alive': 'timeout=5, max=1000',
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return FavoritesPage.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
