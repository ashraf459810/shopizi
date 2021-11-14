class Gender {
  final int id;
  final String title;
  final String icon;

  Gender({this.id, this.title, this.icon});

  factory Gender.fromJson(Map<String, dynamic> data) {
    return Gender(
      id: data['key'],
      title: data['value'],
      icon: 'assets/images/${data['key']}.png',
    );
  }
}
