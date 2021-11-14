import 'package:shopizy/models/banner_model.dart';
import 'package:shopizy/models/brand.dart';
import 'package:shopizy/models/category.dart';
import 'package:shopizy/models/product.dart';

class ShowcaseHomeContent {
  final List<BannerModel> sliders;
  final List<BannerModel> banners;
  final List<Brand> brands;
  final List<Category> categories;
  final List<Product> featuredProducts;

  ShowcaseHomeContent({this.sliders, this.banners, this.brands, this.categories, this.featuredProducts});

  factory ShowcaseHomeContent.fromJson(Map<String, dynamic> data) {
    try {
      return ShowcaseHomeContent(
        sliders: (data['sliders'] as List).map((e) => BannerModel.fromJson(e)).toList(),
        categories: (data['categories'] as List).map((e) => Category.fromJson(e)).toList(),
        brands: (data['brands'] as List).map((e) => Brand.fromJson(e)).toList(),
        featuredProducts: (data['featuredProducts'] as List).map((e) => Product.fromJson(e)).toList(),
        banners: (data['banners'] as List).map((e) => BannerModel.fromJson(e)).toList(),
      );
    } catch (ex) {
      throw ex;
    }
  }
}
