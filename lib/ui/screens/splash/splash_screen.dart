import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/settings/storage_keys.dart';
import 'package:shopizy/ui/screens/base_screen.dart';
import 'package:shopizy/ui/screens/languages/languages_provider.dart';
import 'package:shopizy/ui/screens/languages/welcome_screen.dart';

class SplashScreen extends BaseScreen {
  @override
  Widget body(BuildContext context) {
    Future.delayed(Duration(milliseconds: 2000), () {
      if (GetStorage().read(StorageKeys.language) == null)
        Get.off(() => ChangeNotifierProvider(
              create: (ctx) => LanguagesProvider(),
              child: WelcomeScreen(),
            ));
      else {
        Get.offAndToNamed('/main');
      }
    });
    return Center(
      child: Image.asset('assets/images/app_logo.png', width: 160),
    );
  }
}
