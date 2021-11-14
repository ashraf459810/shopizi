import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/language.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/genders/genders_provider.dart';
import 'package:shopizy/ui/screens/genders/genders_screen.dart';
import 'package:shopizy/ui/screens/languages/languages_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';

import '../base_screen.dart';
import 'widgets/languages_list.dart';
import 'widgets/welcome_carousel.dart';

class WelcomeScreen extends BaseScreen {
  @override
  Widget body(BuildContext context) {
    LanguagesProvider provider = Provider.of(context);
    return provider.supportedLanguages == null
        ? Center(
            child: Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/app_logo.png', width: 150),
                WelcomeCarousel(),
                SizedBox(height: 30),
                LanguagesList(
                  languages: provider.supportedLanguages,
                  showHelpText: true,
                  onLanguageSelected: (Language selectedLanguage) {
                    Get.find<UserController>().subscribeToGeneralLanguageNotifications(selectedLanguage.key);
                    Get.off(
                      () => ChangeNotifierProvider(
                        create: (ctx) => GendersProvider(),
                        child: GendersScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
