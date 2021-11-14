import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shopizy/models/showcase.dart';
import 'package:shopizy/models/showcase_content.dart';
import 'package:shopizy/settings/storage_keys.dart';

import 'api_config.dart';

class RemoteShowcaseService {
  Future<List<Showcase>> fetchShowcases() async {
    int genderId = GetStorage().read(StorageKeys.genderId) ?? 0;
    String url = '$baseUrl/showcase/menu/$genderId';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return (json.decode(response.body) as List).map((i) => Showcase.fromJson(i)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<ShowcaseHomeContent> fetchShowcaseContent(int showcaseId) async {
    String url = '$baseUrl/showcase/homecontent/$showcaseId';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return ShowcaseHomeContent.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<List<Showcase>> fetchShowcasesCategoryTree(int genderId) async {
    String url = '$baseUrl/showcase/categorytree/${genderId ?? 0}';
    try {
      Response response = await http.get(Uri.parse(url), headers: generalHeaders);
      return (json.decode(response.body) as List).map((i) => Showcase.fromJson(i)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
