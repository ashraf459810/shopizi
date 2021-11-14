import 'package:shopizy/models/category.dart';

class Showcase {
  final int id;
  final String name;
  final List<Category> categoryTree;

  Showcase({this.id, this.name, this.categoryTree});

  factory Showcase.fromJson(Map<String, dynamic> data) {
    return Showcase(
      id: data['id'],
      name: data['name'],
      categoryTree: data['categoryTree'] != null ? (data['categoryTree'] as List).map((e) => Category.fromJson(e)).toList() : [],
    );
  }
}
