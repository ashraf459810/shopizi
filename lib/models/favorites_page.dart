import 'package:shopizy/models/product.dart';

class FavoritesPage {
  final List<Product> products;
  final int totalPage;

  FavoritesPage({this.products, this.totalPage});

  factory FavoritesPage.fromJson(Map<String, dynamic> data) {
    return FavoritesPage(
      products: (data['products'] as List).map((e) => Product.fromJson(e)).toList(),
      totalPage: data['lastPage'],
    );
  }
}
