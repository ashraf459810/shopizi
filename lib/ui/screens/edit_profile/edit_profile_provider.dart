import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopizy/models/gender.dart';
import 'package:shopizy/services/global_services/gender_service.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/settings/storage_keys.dart';

class EditProfileProvider with ChangeNotifier {
  bool initialLoading = true, saving = false;

  List<Gender> genders;
  int selectedGenderId;

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  EditProfileProvider() {
    nameController.text = name;
    phoneController.text = phoneNumber;
    selectedGenderId = GetStorage().read('genderId');
    Get.find<GenderService>().fetchGenders().then((value) {
      genders = value;
      initialLoading = false;
      notifyListeners();
    });
  }

  notify() => notifyListeners();

  String get name => FirebaseAuth.instance.currentUser.displayName;

  String get phoneNumber => FirebaseAuth.instance.currentUser.phoneNumber.replaceAll('+964', '');

  Future save(BuildContext ctx) async {
    if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Name is required');
      return;
    }
    saving = true;
    notifyListeners();
    FirebaseAuth.instance.currentUser.updateDisplayName(nameController.text);
    try {
      // Edit Profile
      Get.find<UserController>().editProfile(nameController.text, selectedGenderId);
      GetStorage().write(StorageKeys.genderId, selectedGenderId);
      Fluttertoast.showToast(msg: FlutterI18n.translate(ctx, 'profileupdated'));
    } catch (ex) {
      Fluttertoast.showToast(msg: 'Error ocurred while editing profile');
      print(ex);
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
