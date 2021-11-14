import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class Category {
  final int id;
  final String name;
  final String picturePath;
  final List<Category> children;
  final int orderBy;
  final int genderId;

  Category({this.id, this.name, this.picturePath, this.children, this.orderBy, this.genderId});

  factory Category.fromJson(Map<String, dynamic> data) {
    // in case of showcase category tree
    if (data.containsKey('item')) {
      Map<String, dynamic> item = data['item'];
      return Category(
        id: item['mainCategoryId'],
        name: item['name'],
        orderBy: item['orderBy'],
        genderId: item['genderId'],
        picturePath: item['picturePath'] != null ? '$cdnBaseUrl/${item['picturePath']}' : null,
        children: data['children'] != null ? (data['children'] as List).map((e) => Category.fromJson(e)).toList() : [],
      );
    } else
      // in case of home showcase content
      return Category(
        id: data['mainCategoryId'],
        name: data['name'],
        picturePath: '$cdnBaseUrl/${data['picturePath']}',
        orderBy: data['orderBy'],
        genderId: data['genderId'],
      );
  }

  factory Category.fromSearchResponseParentCategory(Map<String, dynamic> data) {
    return Category(
      id: data['key'],
      name: data['value'],
    );
  }

  DataParameters get dataParameters => DataParameters(
        categoryId: id,
        orderBy: orderBy,
        genderId: genderId,
      );
}
