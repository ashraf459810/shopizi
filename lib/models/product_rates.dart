class ProductRates {
  final String averageRate;
  final int totalRateCount;
  final Map<String, int> rateList;

  ProductRates({this.averageRate, this.totalRateCount, this.rateList});

  factory ProductRates.fromJson(Map<String, dynamic> data) {
    return ProductRates(
      averageRate: data['averageRate'],
      totalRateCount: data['totalRateCount'],
      rateList: (data['rateList'] as Map).map((key, value) => MapEntry(key, value as int)),
    );
  }
}
