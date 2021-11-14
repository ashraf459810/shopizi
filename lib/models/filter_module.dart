class FilterModule {
  final int id;
  final String name;
  final List<FilterModuleItem> filterModuleItems;

  FilterModule(this.id, this.name, this.filterModuleItems);

  factory FilterModule.fromJson(Map<String, dynamic> data) {
    return FilterModule(
      int.tryParse(data['id'] ?? ''),
      data['name'],
      (data['filterModuleItems'] as List).map((e) => FilterModuleItem.fromJson(e)).toList(),
    );
  }
}

class FilterModuleItem {
  final int id;
  final String name;
  final int count;
  bool isSelected;
  String hexCode;
  int parentId;
  List<FilterModuleItem> subcategories;

  FilterModuleItem({this.id, this.name, this.count, this.isSelected, this.hexCode, this.parentId, this.subcategories});

  factory FilterModuleItem.fromJson(Map<String, dynamic> data) {
    return FilterModuleItem(
      id: data['id'],
      name: data['name'],
      count: data['count'],
      isSelected: data['isSelected'],
      hexCode: data['hexCode'],
      parentId: data['parentId'],
      subcategories:
          data['subCategories'] != null ? (data['subCategories'] as List).map((e) => FilterModuleItem.fromJson(e)).toList() : null,
    );
  }
}
