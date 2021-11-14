class DataParameters {
  int categoryId;
  List<int> brandsIds;
  int supplierId;
  int genderId;
  int campaignId;
  int orderBy;
  int sortBy;
  int showcase;
  String keyword;

  DataParameters({
    this.categoryId,
    this.brandsIds,
    this.supplierId,
    this.genderId,
    this.campaignId,
    this.orderBy,
    this.sortBy,
    this.showcase,
    this.keyword,
  });

  factory DataParameters.fromJson(Map<String, dynamic> data) {
    return DataParameters(
      categoryId: data['categoryId'],
      brandsIds: data['brandId'] != null ? [data['brandId']] : null,
      supplierId: data['supplierId'],
      genderId: data['genderId'],
      campaignId: data['campaignId'],
      orderBy: data['orderBy'],
      sortBy: data['sortBy'],
    );
  }

  factory DataParameters.fromNotificationDataJson(Map<String, dynamic> data) {
    return DataParameters(
      sortBy: data['sort'] != null ? int.parse(data['sort'].toString()) : null,
      categoryId: data['category'] != null ? int.tryParse(data['category'].toString()) : null,
      genderId: data['gender'] != null ? int.tryParse(data['gender'].toString()) : null,
      brandsIds: data['brands'] != null ? [int.tryParse(data['brands'].toString())] : null,
      supplierId: data['supplier'] != null ? int.tryParse(data['supplier'].toString()) : null,
    );
  }
}
