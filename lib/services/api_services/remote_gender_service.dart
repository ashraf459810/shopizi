import 'dart:convert';

import 'package:http/http.dart';
import 'package:shopizy/models/gender.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class RemoteGenderService {
  Future<List<Gender>> fetchGenders() async {
    String url = '$baseUrl/genders';
    try {
      Response response = await get(Uri.parse(url), headers: generalHeaders);
      return (json.decode(response.body) as List).map((i) => Gender.fromJson(i)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
