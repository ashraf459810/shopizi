import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/login/mobile_verification_provider.dart';
import 'package:shopizy/ui/screens/login/mobile_verification_screen.dart';

class AuthenticationProvider with ChangeNotifier {
  bool isNewUser, loading = false;
  Function onSuccessfulLogin;

  AuthenticationProvider({this.onSuccessfulLogin});

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  Future checkIsUserExistAndRedirect() async {
    if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Mobile is required');
      return;
    }
    if (phoneController.text.length != 10) {
      Fluttertoast.showToast(msg: 'Invalid Mobile Number');
      return;
    }
    loading = true;
    notifyListeners();
    String mobileNumber = '+964${phoneController.text}';
    isNewUser = !await Get.find<UserController>().checkIsUserExist(mobileNumber);
    loading = false;
    notifyListeners();
    // in case of an already exist customer redirect to verification screen
    if (!isNewUser) {
      isNewUser = null; // to handle coming back from verification screen
      notifyListeners();
      Get.to(() => ChangeNotifierProvider(
            create: (ctx) => MobileVerificationProvider(phoneNumber: mobileNumber, onSuccessfulAuthentication: onSuccessfulLogin),
            child: MobileVerificationScreen(),
          ));
    }
  }

  Future register() async {
    if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Mobile is required');
      return;
    }
    if (nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Name is required');
      return;
    }
    if (phoneController.text.length != 10) {
      Fluttertoast.showToast(msg: 'Invalid Mobile Number');
      return;
    }
    String mobileNumber = '+964${phoneController.text}';
    isNewUser = null; // to handle coming back from verification screen
    String customerName = nameController.text;
    nameController.clear(); // to handle coming back from verification screen
    notifyListeners();
    Get.to(() => ChangeNotifierProvider(
          create: (ctx) =>
              MobileVerificationProvider(phoneNumber: mobileNumber, name: customerName, onSuccessfulAuthentication: onSuccessfulLogin),
          child: MobileVerificationScreen(),
        ));
  }
}
