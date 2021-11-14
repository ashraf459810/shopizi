class SortOption {
  final int id;
  final String name;

  SortOption({this.id, this.name});

  factory SortOption.formJson(Map<String, dynamic> data) {
    return SortOption(
      id: data['id'],
      name: data['name'],
    );
  }
}
