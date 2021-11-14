import 'package:get/get.dart';
import 'package:shopizy/models/gender.dart';
import 'package:shopizy/services/api_services/remote_gender_service.dart';

class GenderService {
  Future<List<Gender>> fetchGenders() async {
    try {
      return await Get.find<RemoteGenderService>().fetchGenders();
    } catch (ex) {
      throw ex;
    }
  }
}
