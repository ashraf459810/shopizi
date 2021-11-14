class ShippingPoint {
  final int id;
  final String title;

  ShippingPoint({this.id, this.title});

  factory ShippingPoint.fromJson(Map<String, dynamic> data) {
    return ShippingPoint(
      id: data['id'],
      title: data['title'],
    );
  }
}
