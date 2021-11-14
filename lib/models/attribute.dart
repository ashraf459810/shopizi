import 'package:shopizy/models/attribute_option.dart';

class Attribute {
  final int id;
  final String name;
  final List<AttributeOption> options;

  Attribute({this.id, this.name, this.options});

  factory Attribute.fromJson(Map<String, dynamic> data) {
    return Attribute(
      id: data['id'],
      name: data['name'],
      options: (data['options'] as List).map((e) => AttributeOption.fromJson(e)).toList(),
    );
  }
}
