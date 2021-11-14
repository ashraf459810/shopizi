import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:shopizy/models/category.dart';
import 'package:shopizy/services/global_services/showcase_service.dart';

class CategoriesProvider with ChangeNotifier {
  bool loading = true;
  int _selectedShowcaseId;

  int get selectedShowcaseId => _selectedShowcaseId;

  get showcases => Get.find<ShowcaseService>().showcasesTree;

  set selectedShowcaseId(int value) {
    _selectedShowcaseId = value;
    notifyListeners();
  }

  CategoriesProvider() {
    Get.find<ShowcaseService>().fetchShowcasesCategoryTree().then((showcaseList) {
      _selectedShowcaseId = Get.find<ShowcaseService>().showcasesTree.value.first.id;
      loading = false;
      notifyListeners();
    });
  }

  List<Category> get selectedShowcaseCategoryTree =>
      Get.find<ShowcaseService>().showcasesTree.value.firstWhere((element) => element.id == _selectedShowcaseId).categoryTree;
}
