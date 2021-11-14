import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:shopizy/models/language.dart';
import 'package:shopizy/services/api_services/api_config.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class RemoteLanguageService {
  Future<List<Language>> fetchSupportedLanguages() async {
    String url = '$baseUrl/languages';
    try {
      Response response = await get(Uri.parse(url));
      return (json.decode(response.body) as List).map((i) => Language.fromJson(i)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> updateUserLanguage(String languageCode) async {
    String url = '$baseUrl/customers/language';
    try {
      Response response = await put(
        Uri.parse(url),
        body: json.encode({'langKey': languageCode}),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode == 200) print('Language updated to: $languageCode on server');
      return response.statusCode == 200;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
