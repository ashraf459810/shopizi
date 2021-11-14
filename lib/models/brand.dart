import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class Brand {
  final int id;
  final String name;
  final String picturePath;
  final bool isSelected;
  final int orderBy;
  final int genderId;
  final int categoryId;

  Brand({this.id, this.name, this.picturePath, this.isSelected, this.orderBy, this.genderId, this.categoryId});

  factory Brand.fromJson(Map<String, dynamic> data) {
    return Brand(
      id: data['relationId'],
      name: data['name'],
      picturePath: data['picturePath'] != null ? '$cdnBaseUrl/${data['picturePath']}' : null,
      isSelected: data['isSelected'] ?? false,
      orderBy: data['orderBy'],
      genderId: data['genderId'],
      categoryId: data['mainCategoryId'],
    );
  }

  DataParameters get dataParameters => DataParameters(
        brandsIds: [id],
        orderBy: orderBy,
        genderId: genderId,
        categoryId: categoryId,
      );
}
