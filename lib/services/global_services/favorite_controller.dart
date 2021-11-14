import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/favorites_page.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/services/api_services/remote_favorite_service.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class FavoriteController extends GetxController {
  RxList<Product> favoriteProducts = <Product>[].obs;
  int page = 1, lastPage = 1;
  final initialLoading = false.obs;
  final moreLoading = false.obs;

  static FavoriteController get instance => Get.find<FavoriteController>();

  ScrollController favoriteProductsGridController = ScrollController();

  FavoriteController() {
    favoriteProductsGridController.addListener(() {
      if (favoriteProductsGridController.position.pixels == favoriteProductsGridController.position.maxScrollExtent)
        fetchFavoritesPage();
    });
  }

  Future<bool> isFavorite(int productId) {
    try {
      return Get.find<RemoteFavoriteService>().isFavorite(productId);
    } catch (ex) {
      throw ex;
    }
  }

  toggleFavorite({Product product}) async {
    if (UserController.instance.isAuthenticated) {
      try {
        await Get.find<RemoteFavoriteService>().toggleFavorite(product.id);
        if (favoriteProducts.firstWhere((element) => element.id == product.id, orElse: () => null) != null)
          favoriteProducts.removeWhere((element) => element.id == product.id);
        else
          favoriteProducts.add(product);
      } catch (ex) {
        throw ex;
      }
    }
  }

  addToFavorite({Product product}) async {
    if (UserController.instance.isAuthenticated) {
      try {
        await Get.find<RemoteFavoriteService>().toggleFavorite(product.id, addToFavorite: true);
        if (favoriteProducts.firstWhere((element) => element.id == product.id, orElse: () => null) == null) {
          favoriteProducts.add(product);
        }
      } catch (ex) {
        throw ex;
      }
    }
  }

  Future fetchFavoritesPage({fromStart = false}) async {
    if (fromStart) {
      page = lastPage = 1;
      favoriteProducts.clear();
      initialLoading(true);
    } else {
      moreLoading(true);
    }
    try {
      if (page <= lastPage) {
        FavoritesPage favPage = await Get.find<RemoteFavoriteService>().fetchFavoritesPage(page: page);
        favoriteProducts.addAll(favPage.products);
        ++page;
        lastPage = favPage.totalPage;
      }
      initialLoading(false);
      moreLoading(false);
    } catch (ex) {
      throw ex;
    }
  }

  clearFavorites() {
    favoriteProducts.clear();
    page = lastPage = 1;
  }
}
