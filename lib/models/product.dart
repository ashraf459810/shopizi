import 'package:shopizy/models/attribute.dart';
import 'package:shopizy/models/brand.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String picturePath;
  final int averageRate;
  final int rateCount;
  final List<String> pictures;
  final List<Attribute> attributes;
  final Brand brand;
  final double oldPrice;
  final double priceAfterDiscount;
  final int discount;
  final List<Attribute> specifications;
  final String groupKey;
  final String url;
  final String brandName;
  final bool isAvailable;
  final bool haspriceperoption;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.picturePath,
      this.averageRate,
      this.rateCount,
      this.pictures,
      this.attributes,
      this.brand,
      this.oldPrice,
      this.priceAfterDiscount,
      this.discount,
      this.specifications,
      this.groupKey,
      this.url,
      this.brandName,
      this.isAvailable,
      this.haspriceperoption});

  factory Product.fromJson(Map<String, dynamic> data) {
    try {
      String brandName = data['brandName'] != null
          ? data['brandName']
          : data['brand'] != null
              ? Brand.fromJson(data['brand']).name
              : null;
      return Product(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        price: data['price'].toDouble(),
        picturePath: '$cdnBaseUrl/${data['picturePath']}',
        averageRate: double.parse(data['averageRate']).round(),
        rateCount: data['rateCount'],
        pictures: data['pictures'] != null
            ? (data['pictures'] as List)
                .map((e) => '$cdnBaseUrl/${(e as Map)['path'] as String}')
                .toList()
            : [],
        attributes: data['attributes'] != null
            ? (data['attributes'] as List)
                .map((e) => Attribute.fromJson(e))
                .toList()
            : [],
        brand: data['brand'] != null ? Brand.fromJson(data['brand']) : null,
        oldPrice: data['oldPrice'].toDouble(),
        priceAfterDiscount: data['priceAfterDiscount'].toDouble(),
        discount: data['discount'],
        specifications: data['specifications'] != null
            ? (data['specifications'] as List)
                .map((e) => Attribute.fromJson(e))
                .toList()
            : [],
        groupKey: data['groupKey'],
        url: '$webBaseUrl${data['url']}',
        brandName: brandName,
        isAvailable: data['isAvailable'],
        haspriceperoption: data['hasPricePerOption'],
      );
    } catch (ex) {
      print('Error parsing product');
      throw ex;
    }
  }
}
