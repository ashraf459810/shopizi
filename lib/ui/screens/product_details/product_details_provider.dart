import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopizy/models/add_to_cart_request.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/models/review.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/favorite_controller.dart';
import 'package:shopizy/services/global_services/product_service.dart';
import 'package:shopizy/settings/storage_keys.dart';

class ProductDetailsProvider with ChangeNotifier {
  bool loading = true, editCart = false;
  int productId;
  Product product;
  Map<int, int> selectedOptions = {};
  List<Product> groupProducts = [];
  List<Product> relatedProducts = [];
  List<Review> reviews = [];
  int requestedQuantity = 1;
  bool isFavorite;
  int lastSeenProductsLimit = 3;
  get oldprice => product.oldPrice;
  CarouselController carouselController = CarouselController();

  ProductDetailsProvider(this.productId) {
    fetchProductWithFavoriteStatus(productId);
  }

  fetchProductWithFavoriteStatus(int productId) {
    reviews.clear();
    selectedOptions = {};
    Get.find<ProductService>().fetchProductInfo(productId).then((productInfo) {
      this.product = productInfo;
      loading = false;
      notifyListeners();
      addToLastSeenProducts();
      if (product.groupKey != null)
        Get.find<ProductService>()
            .fetchGroupProducts(productId, product.groupKey)
            .then((products) {
          this.groupProducts = products;
          notifyListeners();
        });
      Get.find<ProductService>()
          .fetchRelatedProducts(productId)
          .then((products) {
        this.relatedProducts = products;
        notifyListeners();
      });
      Get.find<ProductService>()
          .fetchProductReviewsPage(productId, 1)
          .then((reviewsPage) {
        this.reviews.addAll(reviewsPage.reviews.take(5));
        notifyListeners();
      });
    });
    getFavoriteStatus();
  }

  bool isOptionSelected(int optionId) =>
      selectedOptions.values.any((element) => element == optionId);

  Future getFavoriteStatus() async {
    isFavorite = await Get.find<FavoriteController>().isFavorite(productId);
    notifyListeners();
  }

  // product.attributes.length == 0 => product has no attributes to select
  // product.attributes.length == selectedOptions.length => user has selected values for all attributes
  bool get canAddToCart =>
      product.attributes.length == 0 ||
      product.attributes.length == selectedOptions.length;

  addToCart(BuildContext ctx) async {
    editCart = true;
    notifyListeners();
    List<AttributeSelectedOption> options = [];
    selectedOptions.forEach((key, value) {
      options.add(AttributeSelectedOption(attributeId: key, optionId: value));
    });
    try {
      await Get.find<CartController>()
          .addToCart(product.id, requestedQuantity, options);
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(ctx, 'productaddedtocart'));
      requestedQuantity = 1;
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
      requestedQuantity = 1;
    }
    editCart = false;
    notifyListeners();
  }

  addToLastSeenProducts() {
    Map<int, String> lastSeenProducts =
        ((GetStorage().read(StorageKeys.lastSeenProducts) ?? {}) as Map)
            .map((key, value) => MapEntry(int.parse(key), value as String));
    // to put last seen product at first
    lastSeenProducts = {productId: product.picturePath}
      ..addAll(lastSeenProducts);
    // set Limit
    lastSeenProducts = Map.fromIterable(
        lastSeenProducts.keys.take(lastSeenProductsLimit),
        value: (k) => lastSeenProducts[k]);
    GetStorage().write(StorageKeys.lastSeenProducts,
        lastSeenProducts.map((key, value) => MapEntry(key.toString(), value)));
  }

  toggleFavorite(BuildContext ctx, {addToFavorite = false}) async {
    addToFavorite
        ? await FavoriteController.instance.addToFavorite(product: product)
        : await FavoriteController.instance.toggleFavorite(product: product);
    isFavorite = !isFavorite;
    Fluttertoast.showToast(
        msg: FlutterI18n.translate(
            ctx,
            isFavorite
                ? 'productaddedtofavorites'
                : 'productremovedfromfavorites'));
    notifyListeners();
  }
}
