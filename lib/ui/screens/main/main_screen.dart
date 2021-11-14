import 'dart:async';

import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/services/api_services/api_config.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/account/account_screen.dart';
import 'package:shopizy/ui/screens/cart/cart_provider.dart';
import 'package:shopizy/ui/screens/cart/cart_screen.dart';
import 'package:shopizy/ui/screens/categories/categories_provider.dart';
import 'package:shopizy/ui/screens/categories/categories_screen.dart';
import 'package:shopizy/ui/screens/favorites/favorites_screen.dart';
import 'package:shopizy/ui/screens/home/home_screen.dart';
import 'package:shopizy/ui/screens/order_details/order_details_provider.dart';
import 'package:shopizy/ui/screens/order_details/order_details_screen.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/screens/reviews/reviews_screen.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:uni_links/uni_links.dart';

class MainScreenController extends GetxController {
  final _currentIndex = 0.obs;

  get currentIndex => _currentIndex.value;

  set currentIndex(value) {
    if (pageViewController.hasClients) pageViewController.jumpToPage(value);
    _currentIndex.value = value;
  }

  PageController pageViewController = PageController(initialPage: 0);

  List<Widget> _pages = [
    HomeScreen(),
    ChangeNotifierProvider(
      create: (_) => CategoriesProvider(),
      child: CategoriesScreen(),
    ),
    FavoritesScreen(),
    ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: CartScreen(),
    ),
    AccountScreen(),
  ];

  Widget get currentPage => _pages[currentIndex];
}

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  Uri _initialUri;
  Uri _latestUri;
  Object _err;
  StreamSubscription _sub;
  MainScreenController controller = MainScreenController();

  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: '_rating',
    minDays: 0,
    minLaunches: 3,
    remindDays: 3,
    remindLaunches: 10,
  );
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void initState() {
    // to get notifications count onResume
    WidgetsBinding.instance.addObserver(this);
    _configureFcm();
    handleIncomingLinks();
    getInitialLink().then((String link) {
      if (link != null) {
        if (link.contains('$webBaseUrl/shop/products/')) {
          int productId = int.parse(link.substring(link.lastIndexOf('/') + 1));
          Get.to(
            () => ChangeNotifierProvider(
              create: (_) => ProductDetailsProvider(productId),
              child: ProductDetailsScreen(),
            ),
          );
        } else if (link.contains('$webBaseUrl/shop/catalog')) {
          var uri = Uri.parse(link);
          int category = uri.queryParameters['category'] != null
              ? int.tryParse(uri.queryParameters['category'])
              : null;
          int gender = uri.queryParameters['gender'] != null
              ? int.tryParse(uri.queryParameters['gender'])
              : null;
          List<int> brands = uri.queryParameters['brands'] != null
              ? uri.queryParameters['brands']
                  .split(',')
                  .map((e) => int.parse(e))
                  .toList()
              : null;
          Get.to(
            () => ChangeNotifierProvider(
              create: (_) => SearchProvider(
                  initialDataParameters: DataParameters(
                      categoryId: category,
                      genderId: gender,
                      brandsIds: brands)),
              child: SearchScreen(),
            ),
          );
        }
      }
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<UserController>().updateNotificationsCount();
      if (UserController.instance.isAuthenticated &&
          Get.find<CartController>().cartInfo.value.id == null)
        Get.find<CartController>().fetchCart();
    }
  }

  Future<void> _configureFcm() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) => redirectNotification(message));
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) => redirectNotification(message));
  }

  redirectNotification(RemoteMessage message) {
    if (message != null) {
      if (message.data.containsKey('product'))
        Get.to(
          () => ChangeNotifierProvider(
            create: (ctx) =>
                ProductDetailsProvider(int.parse(message.data['product'])),
            child: ProductDetailsScreen(),
          ),
          preventDuplicates: false,
        );
      else if (message.data['category'] != null ||
          message.data['brands'] != null ||
          message.data['gender'] != null ||
          message.data['sort'] != null)
        Get.to(
            () => ChangeNotifierProvider(
                  create: (_) => SearchProvider(
                      initialDataParameters:
                          DataParameters.fromNotificationDataJson(message.data),
                      pageTitle: message.data['title']),
                  child: SearchScreen(),
                ),
            preventDuplicates: false);
      else if (message.data['order'] != null)
        Get.to(
            () => ChangeNotifierProvider(
                  create: (ctx) =>
                      OrderDetailsProvider(int.parse(message.data['order'])),
                  child: OrderDetailsScreen(),
                ),
            preventDuplicates: false);
      else if (message.data['review'] != null)
        Get.to(() => ReviewsScreen(), preventDuplicates: false);
    } else
      setUpRateApp();
  }

  setUpRateApp() {
    _rateMyApp.init().then(
      (_) {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.showRateDialog(
            context,
            title: FlutterI18n.translate(context, 'rateus'),
            message: FlutterI18n.translate(context, 'rateusmessage'),
            rateButton: FlutterI18n.translate(context, 'rate'),
            noButton: FlutterI18n.translate(context, 'nothanks'),
            laterButton: FlutterI18n.translate(context, 'maybelater'),
            listener: (button) {
              switch (button) {
                case RateMyAppDialogButton.rate:
                  LaunchReview.launch(
                    androidAppId: 'com.shopiziapp',
                    iOSAppId: 'com.shopiziapp',
                  );
                  break;
                case RateMyAppDialogButton.later:
                  break;
                case RateMyAppDialogButton.no:
                  break;
              }
              return true; // Return false if you want to cancel the click event.
            },
          );
        }
      },
    );
  }

  // this function is used for exit the application, user must click back button two times
  DateTime _currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(context, 'pressbackagaintoexit'),
          toastLength: Toast.LENGTH_LONG);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.find<MainScreenController>();
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: PageView(
          children: controller._pages,
          controller: controller.pageViewController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            bottomNavigationItem(FlutterI18n.translate(context, "home"),
                Icons.home, controller._currentIndex.value == 0),
            bottomNavigationItem(FlutterI18n.translate(context, "categories"),
                Icons.search, controller._currentIndex.value == 1),
            bottomNavigationItem(FlutterI18n.translate(context, "favorites"),
                Icons.favorite_border, controller._currentIndex.value == 2),
            bottomNavigationItem(
                FlutterI18n.translate(context, "cart"),
                Icons.shopping_cart_outlined,
                controller._currentIndex.value == 3,
                count: CartController.instance.cartInfo.value.totalQty),
            bottomNavigationItem(FlutterI18n.translate(context, "account"),
                Icons.settings, controller._currentIndex.value == 4),
          ],
          onTap: (index) => controller.currentIndex = index,
        ),
      ),
    );
  }

  bottomNavigationItem(String title, IconData iconData, bool isSelected,
          {int count}) =>
      BottomNavigationBarItem(
        title: Text(
          title,
          style: TextStyle(
              color: isSelected ? AppColors.PRIMARY_COLOR : Colors.grey),
        ),
        activeIcon: count != null && count > 0
            ? Badge(
                badgeContent: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                badgeColor: AppColors.PRIMARY_COLOR,
                child: Icon(iconData, color: AppColors.PRIMARY_COLOR),
              )
            : Icon(iconData, color: AppColors.PRIMARY_COLOR),
        icon: count != null && count > 0
            ? Badge(
                badgeContent: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                badgeColor: AppColors.PRIMARY_COLOR,
                child: Icon(iconData),
              )
            : Icon(iconData),
      );

  void handleIncomingLinks() {
    // if (!kIsWeb) {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _sub = uriLinkStream.listen((Uri uri) {
      if (uri != null) {
        String link = uri.toString();
        if (link.contains('$webBaseUrl/shop/products/')) {
          int productId = int.parse(link.substring(link.lastIndexOf('/') + 1));
          Get.to(
            () => ChangeNotifierProvider(
              create: (_) => ProductDetailsProvider(productId),
              child: ProductDetailsScreen(),
            ),
          );
        } else if (link.contains('$webBaseUrl/shop/catalog')) {
          var uri = Uri.parse(link);
          int category = uri.queryParameters['category'] != null
              ? int.tryParse(uri.queryParameters['category'])
              : null;
          int gender = uri.queryParameters['gender'] != null
              ? int.tryParse(uri.queryParameters['gender'])
              : null;
          List<int> brands = uri.queryParameters['brands'] != null
              ? uri.queryParameters['brands']
                  .split(',')
                  .map((e) => int.parse(e))
                  .toList()
              : null;
          Get.to(
            () => ChangeNotifierProvider(
              create: (_) => SearchProvider(
                  initialDataParameters: DataParameters(
                      categoryId: category,
                      genderId: gender,
                      brandsIds: brands)),
              child: SearchScreen(),
            ),
          );
        }
      }
    }, onError: (Object err) {
      if (!mounted) return;
      print('got err: $err');
      setState(() {
        _latestUri = null;
        if (err is FormatException) {
          _err = err;
        } else {
          _err = null;
        }
      });
    });
  }
}
// }
