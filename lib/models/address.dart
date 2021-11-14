class Address {
  final int id;
  String title;
  String phoneNumber;
  String address;
  int shippingPointId;
  bool isSelected;
  String name;
  String city;

  Address({this.id, this.title, this.phoneNumber, this.address, this.shippingPointId, this.isSelected, this.name, this.city});

  factory Address.fromJson(Map<String, dynamic> data) {
    return Address(
      id: data['addressId'],
      title: data['title'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      shippingPointId: data['shippingPointId'],
      isSelected: data['isSelected'],
      name: data['name'],
      city: data['city'],
    );
  }

  factory Address.fromOrderDetailsJson(Map<String, dynamic> data) {
    return Address(
      phoneNumber: data['phone'],
      address: data['address'],
      name: data['name'],
      city: data['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'address': address,
      'phoneNumber': phoneNumber,
      'shippingPointId': shippingPointId,
      'name': name,
    };
  }
}
