import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/gender.dart';
import 'package:shopizy/services/global_services/gender_service.dart';

class GendersProvider with ChangeNotifier {
  List<Gender> genders;

  GendersProvider() {
    Get.find<GenderService>().fetchGenders().then((value) {
      genders = value;
      notifyListeners();
    });
  }
}
