import 'package:get/get.dart';
import 'package:shopizy/models/language.dart';
import 'package:shopizy/services/api_services/remote_language_service.dart';

class LanguageService {
  List<Language> supportedLanguages;

  Future<List<Language>> fetchSupportedLanguages() async {
    try {
      return supportedLanguages =
          await Get.find<RemoteLanguageService>().fetchSupportedLanguages();
    } catch (ex) {
      throw ex;
    }
  }

  Future<bool> updateUserLanguage(String languageCode) async {
    try {
      return await Get.find<RemoteLanguageService>()
          .updateUserLanguage(languageCode);
    } catch (ex) {
      throw ex;
    }
  }
}
