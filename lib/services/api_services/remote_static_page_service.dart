import 'dart:convert';

import 'package:http/http.dart';

import 'api_config.dart';

class RemoteStaticPageService {
  Future<String> fetchPageContent(String pageName) async {
    String url = '$baseUrl/pages/$pageName';
    try {
      Response response = await get(Uri.parse(url), headers: generalHeaders);
      return json.decode(response.body)['content'];
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
