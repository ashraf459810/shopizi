import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/favorite_controller.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class UserProvider with ChangeNotifier {
  UserController userService = Get.find<UserController>();

  AuthenticationState get authenticationState => userService.authenticationState.value;

  String get firebaseToken => userService.firebaseToken;

  Future verify(String verificationId, String code, String name, Function onSuccessfulLogin, Function onFailure) async {
    try {
      // Save anonymous user id
      String anonymousUserId = userService.userId;
      UserCredential userCredential = await Get.find<UserController>().verifyCodeAndSignIn(verificationId, code);
      if (userCredential != null) {
        if (name != null) await FirebaseAuth.instance.currentUser.updateProfile(displayName: name);
        Get.find<UserController>().firebaseToken = await userCredential.user.getIdToken();
        await Get.find<UserController>().loginToShopizy(name: name, anonymousUserId: anonymousUserId);
        await FavoriteController.instance.fetchFavoritesPage(fromStart: true);
        await CartController.instance.fetchCart();
        Get.back();
        Get.back();
        if (onSuccessfulLogin != null) onSuccessfulLogin();
      } else {
        Fluttertoast.showToast(msg: 'failed');
        onFailure();
      }
    } catch (ex) {
      print(ex);
      onFailure();
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
