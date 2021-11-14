import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/settings/storage_keys.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';

class SearchExpressionProvider with ChangeNotifier {
  int searchHistoryLimit = 15;

  TextEditingController keywordController = TextEditingController();

  Map<int, String> get lastSeenProducts =>
      ((GetStorage().read(StorageKeys.lastSeenProducts) ?? {}) as Map).map((key, value) => MapEntry(int.parse(key), value as String));

  List<String> get lastSearchKeywords =>
      ((GetStorage().read(StorageKeys.lastSearchKeywords) ?? []) as List).map((e) => e as String).toList();

  onKeywordSubmit() async {
    if (keywordController.text.trim().isNotEmpty) {
      await addToLastSearchKeyword(keywordController.text.trim());
      redirectToSearch(keywordController.text);
    }
  }

  redirectToSearch(String keyword) {
    Get.off(
      () => ChangeNotifierProvider(
        create: (_) => SearchProvider(
          pageTitle: keyword,
          initialDataParameters: DataParameters(keyword: keyword),
        ),
        child: SearchScreen(),
      ),
    );
  }

  addToLastSearchKeyword(String keyword) {
    List<String> searchKeywords = lastSearchKeywords;
    if (searchKeywords.contains(keyword)) searchKeywords.remove(keyword);
    searchKeywords.insert(0, keyword);
    // remove older than last limit saved keywords
    searchKeywords =
        searchKeywords.sublist(0, searchKeywords.length > searchHistoryLimit ? searchHistoryLimit : searchKeywords.length);

    return GetStorage().write(StorageKeys.lastSearchKeywords, searchKeywords);
  }

  removeFromSearchHistory(int index) async {
    List<String> searchKeywords = lastSearchKeywords;
    searchKeywords.removeAt(index);
    await GetStorage().write(StorageKeys.lastSearchKeywords, searchKeywords);
    notifyListeners();
  }
}
