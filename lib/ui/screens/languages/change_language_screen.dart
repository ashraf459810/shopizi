import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/language.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/language_service.dart';
import 'package:shopizy/services/global_services/showcase_service.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/languages/languages_provider.dart';
import 'package:shopizy/ui/screens/languages/widgets/languages_list.dart';
import 'package:shopizy/ui/theme/app_colors.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    LanguagesProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        centerTitle: true,
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'language'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: provider.supportedLanguages == null
          ? Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: LanguagesList(
                languages: provider.supportedLanguages,
                showHelpText: false,
                showFlag: false,
                onLanguageSelected: (Language selectedLanguage) async {
                  showLoading();
                  await Get.find<LanguageService>()
                      .updateUserLanguage(selectedLanguage.key);
                  await Get.find<UserController>()
                      .unsubscribeFromLanguageNotifications(provider
                          .supportedLanguages
                          .map((e) => e.key)
                          .where((element) => element != selectedLanguage.key)
                          .toList());
                  await Get.find<UserController>()
                      .subscribeToGeneralLanguageNotifications(
                          selectedLanguage.key);
                  Get.find<ShowcaseService>().clearData();
                  Get.find<CartController>().clear();
                  Get.offAllNamed('/splash');
                },
              ),
            ),
    );
  }

  showLoading() => showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (ctx) => WillPopScope(
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR)),
                SizedBox(height: 12),
                Text(FlutterI18n.translate(context, 'switchapplang'),
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          onWillPop: () async => false,
        ),
      );
}
