import 'package:get/get.dart';
import 'package:shopizy/services/api_services/remote_static_page_service.dart';

class StaticPageService {
  Future<String> fetchPageContent(String pageName) async {
    try {
      return await Get.find<RemoteStaticPageService>().fetchPageContent(pageName);
    } catch (ex) {
      throw ex;
    }
  }
}
