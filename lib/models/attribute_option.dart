class AttributeOption {
  final int id;
  final String name;
  final bool status;
  final PropertyPrice propertyPrice;
  final String attributeName;

  AttributeOption({this.id, this.name, this.status, this.propertyPrice, this.attributeName});

  factory AttributeOption.fromJson(Map<String, dynamic> data) {
    return AttributeOption(
      id: data['id'],
      name: data['name'],
      status: data['status'] ?? true,
      propertyPrice: data['propertyPrice'] != null ? PropertyPrice.formJson(data['propertyPrice']) : null,
    );
  }

  factory AttributeOption.fromOrderItemOptionJson(Map<String, dynamic> data) {
    return AttributeOption(
      name: data['optionName'],
      attributeName: data['attributeName'],
    );
  }
}

class PropertyPrice {
  final double price;
  final double oldPrice;
  final double priceAfterDiscount;

  PropertyPrice({this.price, this.oldPrice, this.priceAfterDiscount});

  factory PropertyPrice.formJson(Map<String, dynamic> data) {
    return PropertyPrice(
      price: data['price'].toDouble(),
      oldPrice: data['oldPrice'].toDouble(),
      priceAfterDiscount: data['priceAfterDiscount'].toDouble(),
    );
  }
}
