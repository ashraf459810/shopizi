import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/providers/user_provider.dart';
import 'package:shopizy/settings/storage_keys.dart';
import 'package:shopizy/ui/screens/main/main_screen.dart';
import 'package:shopizy/ui/screens/splash/splash_screen.dart';
import 'package:shopizy/ui/theme/app_theme.dart';

import 'app_binding.dart';
import 'kurdish_support/ckb_material_localization_delegate.dart';
import 'kurdish_support/ckb_widget_localization_delegate.dart';

AppTheme appTheme;

void main() async {
  // to show transparent status bar on Android
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark),
  );
  // Initialize storage driver
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase
  await Firebase.initializeApp();
  // Set Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(ShopizyApp());
  });
}

class ShopizyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme();
    Locale appLocale = Locale(GetStorage().read(StorageKeys.language) ??
        Get.deviceLocale.languageCode);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: GetMaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        initialBinding: AppBinding(),
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: NetworkFileTranslationLoader(
              baseUri: Uri.https("api.shopizi.co", "resources/mobile/"),
              forcedLocale: appLocale,
            ),
          ),
          CkbMaterialLocalizations.delegate,
          CkbWidgetLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: appTheme.getTheme(context),
        debugShowCheckedModeBanner: false,
        locale: appLocale,
        textDirection:
            appLocale.languageCode == 'ar' || appLocale.languageCode == 'ku'
                ? TextDirection.rtl
                : TextDirection.ltr,
        getPages: [
          GetPage(name: '/main', page: () => MainScreen()),
          GetPage(name: '/splash', page: () => SplashScreen()),
        ],
        home: SplashScreen(),
      ),
    );
  }
}
