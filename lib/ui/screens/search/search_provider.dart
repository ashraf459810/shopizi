import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/category.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/models/search_parameters.dart';
import 'package:shopizy/models/search_response.dart';
import 'package:shopizy/services/global_services/product_service.dart';

class SearchProvider with ChangeNotifier {
  bool initialLoading = true, moreLoading = false;

  String pageTitle;
  int page = 0, totalProducts;
  ScrollController scrollController = ScrollController();

  // Parameters
  DataParameters initialDataParameters;
  SearchParameters searchParameters;

  // Response
  SearchResponse searchResponse;
  List<Product> products;

  SearchProvider({this.pageTitle, this.initialDataParameters}) {
    loadInitialSearchResults();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        ++page;
        moreLoading = true;
        notifyListeners();
        search();
      }
    });
  }

  loadInitialSearchResults() {
    searchParameters = SearchParameters.fromDataParameters(initialDataParameters);
    Get.find<ProductService>().searchProducts(searchParameters).then((SearchResponse response) {
      products = response.productList;
      totalProducts = response.totalProducts;
      this.searchResponse = response;
      initialLoading = false;
      notifyListeners();
    });
  }

  updateSearchResponse(SearchResponse searchResponse) {
    this.searchResponse = searchResponse;
    notifyListeners();
  }

  setSortOption(int optionId) {
    searchParameters.sort = optionId;
    search(clearPreviousResults: true);
    Get.back();
  }

  List<Category> get parentCategories =>
      searchResponse.categories.length > 1 ? searchResponse.categories.sublist(0, searchResponse.categories.length - 1) : [];

  toggleBrand(int brandId) {
    if (searchParameters.brandIds.contains(brandId))
      searchParameters.brandIds.remove(brandId);
    else
      searchParameters.brandIds.add(brandId);
  }

  togglePropertyValue(int propertyId, int valueId) {
    if (searchParameters.propertyFilter.containsKey(propertyId)) {
      if (searchParameters.propertyFilter[propertyId].contains(valueId)) {
        searchParameters.propertyFilter[propertyId].remove(valueId);
        if (searchParameters.propertyFilter[propertyId].isEmpty) searchParameters.propertyFilter.remove(propertyId);
      } else {
        searchParameters.propertyFilter[propertyId].add(valueId);
      }
    } else {
      searchParameters.propertyFilter.putIfAbsent(propertyId, () => [valueId]);
    }
  }

  toggleColor(int colorId) {
    if (searchParameters.colorIds.contains(colorId))
      searchParameters.colorIds.remove(colorId);
    else
      searchParameters.colorIds.add(colorId);
  }

  Future search({clearPreviousResults = false}) async {
    if (clearPreviousResults) clearPagination();
    if (!clearPreviousResults && products.length == totalProducts) return;
    searchParameters.pageIndex = page;
    SearchResponse response = await Get.find<ProductService>().searchProducts(searchParameters);
    totalProducts = response.totalProducts;
    products.addAll(response.productList);
    this.searchResponse = response;
    moreLoading = false;
    notifyListeners();
  }

  notify() => notifyListeners();

  clearPagination() {
    products.clear();
    page = 0;
    totalProducts = 0;
  }
}
