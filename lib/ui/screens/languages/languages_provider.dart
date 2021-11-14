import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/language.dart';
import 'package:shopizy/services/global_services/language_service.dart';

class LanguagesProvider with ChangeNotifier {
  List<Language> supportedLanguages;

  LanguagesProvider() {
    Get.find<LanguageService>().fetchSupportedLanguages().then((value) {
      supportedLanguages = value;
      notifyListeners();
    });
  }
}
