import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/providers/user_provider.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class MobileVerificationProvider with ChangeNotifier {
  String verificationId, name;
  int resendToken;
  Function onSuccessfulAuthentication;
  bool isLoading = false;
  String phoneNumber;
  bool showResendButton = false;
  RestartableTimer _resendShowTimer;

  MobileVerificationProvider({this.phoneNumber, this.name, this.onSuccessfulAuthentication}) {
    sendVerificationSMS();
    _resendShowTimer = new RestartableTimer(Duration(seconds: 15), () {
      showResendButton = true;
      notifyListeners();
    });
  }

  bool _isCodeComplete = false;
  String code;

  bool get isVerificationButtonEnabled => _isCodeComplete && verificationId != null;

  sendVerificationSMS() {
    _resendShowTimer?.reset();
    showResendButton = false;
    notifyListeners();
    Get.find<UserController>().verifyPhoneNumber(
      phoneNumber: phoneNumber,
      resendToken: resendToken,
      onCodeSent: (verificationId, resendToken) {
        this.verificationId = verificationId;
        this.resendToken = resendToken;
        notifyListeners(); // to enable verify button
      },
    );
  }

  toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  set isCodeComplete(bool isEnabled) {
    _isCodeComplete = isEnabled;
    notifyListeners();
  }

  verifyCode(BuildContext context) {
    if (verificationId != null)
      Provider.of<UserProvider>(context, listen: false).verify(verificationId, code, name, () {
        toggleLoading();
        onSuccessfulAuthentication();
      }, () {
        toggleLoading();
      });
    else
      Fluttertoast.showToast(msg: 'Verification code is incorrect');
  }

  String errMessage;
  showErrorMessage(String errorMessage) {
    errMessage = errorMessage;
    notifyListeners();
  }

  hideErrorMessage() {
    errMessage = null;
    notifyListeners();
  }
}
