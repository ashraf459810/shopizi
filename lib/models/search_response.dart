import 'package:shopizy/models/category.dart';
import 'package:shopizy/models/filter_module.dart';
import 'package:shopizy/models/price_filter_module.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/models/sort_option.dart';

class SearchResponse {
  final int totalProducts;
  final List<Product> productList;
  final FilterModule brandFilterModule;
  final FilterModule genderFilterModule;
  final FilterModule colorFilterModule;
  final PriceFilterModule priceModule;
  final FilterModule categoryFilterModule;
  final List<FilterModule> attributeFilterModule;
  final List<SortOption> sortModule;

  // this is for moving up in hierarchy
  final List<Category> categories;

  SearchResponse({
    this.totalProducts,
    this.productList,
    this.brandFilterModule,
    this.genderFilterModule,
    this.colorFilterModule,
    this.priceModule,
    this.categoryFilterModule,
    this.attributeFilterModule,
    this.sortModule,
    this.categories,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> data) {
    try {
      return SearchResponse(
        totalProducts: (data['result']['totalProducts']),
        productList: (data['result']['productList'] as List).map((e) => Product.fromJson(e)).toList(),
        brandFilterModule:
            data['result']['brandFilterModule'] != null ? FilterModule.fromJson(data['result']['brandFilterModule']) : null,
        genderFilterModule:
            data['result']['genderFilterModule'] != null ? FilterModule.fromJson(data['result']['genderFilterModule']) : null,
        colorFilterModule:
            data['result']['colorFilterModule'] != null ? FilterModule.fromJson(data['result']['colorFilterModule']) : null,
        priceModule: data['result']['priceModule'] != null ? PriceFilterModule.fromJson(data['result']['priceModule']) : null,
        categoryFilterModule:
            data['result']['categoryFilterModule'] != null ? FilterModule.fromJson(data['result']['categoryFilterModule']) : null,
        attributeFilterModule: data['result']['attributeFilterModule'] != null
            ? (data['result']['attributeFilterModule'] as List).map((e) => FilterModule.fromJson(e)).toList()
            : null,
        categories: data['categories'] != null
            ? (data['categories'] as List).map((e) => Category.fromSearchResponseParentCategory(e)).toList()
            : [],
        sortModule: data['result']['sortModules'] != null
            ? (data['result']['sortModules'] as List).map((e) => SortOption.formJson(e)).toList()
            : [],
      );
    } catch (ex) {
      print('Error Parsing SearchResponse: $data');
      throw ex;
    }
  }
}
