import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/showcase.dart';
import 'package:shopizy/services/global_services/showcase_service.dart';
import 'package:shopizy/ui/screens/home/showcase_page.dart';

class HomeController extends GetxController {
  var showcaseTabs = <Tab>[].obs;
  var showcasePages = <Widget>[].obs;

  @override
  void onInit() {
    fetchShowcases();
    super.onInit();
  }

  Future fetchShowcases() async {
    List<Showcase> showcases = await Get.find<ShowcaseService>().fetchShowcases(reload: true);
    showcaseTabs.value = showcases.map((showcase) => Tab(text: showcase.name ?? '')).toList();
    showcasePages.value = showcases.map((showcase) => ShowcasePage(showcase.id, showcase.name)).toList();
  }
}
