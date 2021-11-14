class AddToCartRequest {
  final int productId;
  final int qty;
  final List<AttributeSelectedOption> attributeOptions;

  AddToCartRequest({this.productId, this.qty, this.attributeOptions});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'qty': qty,
      'attributeOptions': attributeOptions,
    };
  }
}

class AttributeSelectedOption {
  final int attributeId;
  final int optionId;

  AttributeSelectedOption({this.attributeId, this.optionId});

  Map<String, dynamic> toJson() {
    return {
      'attributeId': attributeId,
      'optionId': optionId,
    };
  }
}
