import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopizy/models/showcase.dart';
import 'package:shopizy/models/showcase_content.dart';
import 'package:shopizy/services/api_services/remote_showcase_service.dart';
import 'package:shopizy/settings/storage_keys.dart';

class ShowcaseService {
  List<Showcase> _showcases;
  final showcasesTree = <Showcase>[].obs;

  Future<List<Showcase>> fetchShowcases({bool reload = false}) async {
    if (_showcases == null || reload) {
      try {
        return await Get.find<RemoteShowcaseService>().fetchShowcases();
      } catch (ex) {
        throw ex;
      }
    } else
      return _showcases;
  }

  Future<ShowcaseHomeContent> fetchShowcaseContent(int showcaseId) async {
    try {
      return await Get.find<RemoteShowcaseService>().fetchShowcaseContent(showcaseId);
    } catch (ex) {
      throw ex;
    }
  }

  Future fetchShowcasesCategoryTree() async {
    try {
      int genderId = GetStorage().read(StorageKeys.genderId);
      showcasesTree(await Get.find<RemoteShowcaseService>().fetchShowcasesCategoryTree(genderId));
    } catch (ex) {
      throw ex;
    }
  }

  clearData() {
    _showcases?.clear();
    showcasesTree.value = null;
  }
}
