import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/services/api_services/remote_user_service.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/notification_service.dart';
import 'package:shopizy/ui/screens/login/authentication_provider.dart';
import 'package:shopizy/ui/screens/login/authentication_screen.dart';
import 'package:shopizy/ui/screens/main/main_screen.dart';
import 'package:shopizy/ui/screens/order_details/order_details_provider.dart';
import 'package:shopizy/ui/screens/order_details/order_details_screen.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/screens/reviews/reviews_screen.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';

class UserController {
  String firebaseToken, fcmToken;
  String userId;
  final authenticationState = AuthenticationState.unauthenticated.obs;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidNotificationChannel announcementChannel, campaignsChannel, ordersChannel;
  final notificationsCount = 0.obs;

  static UserController get instance => Get.find<UserController>();

  UserController() {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      authenticationState(
        user == null
            ? AuthenticationState.unauthenticated
            : user.isAnonymous
                ? AuthenticationState.anonymous
                : AuthenticationState.real,
      );
      if (user == null) {
        firebaseToken = null;
        userId = null;
        CartController.instance.clear();
      } else {
        setUpFCM();
        FirebaseAuth.instance.idTokenChanges().listen((event) async {
          if (event != null) {
            firebaseToken = await event.getIdToken();
            userId = event.uid;
            if (authenticationState.value == AuthenticationState.real) {
              setUpFCM();
              // Get notifications count
              updateNotificationsCount();
              Get.find<CartController>().fetchCart();
            }
            print('FIREBASE TOKEN: $firebaseToken');
            print('USER ID: $userId');
          }
        });
      }
    });
    createNotificationChannels();
  }

  updateNotificationsCount() async {
    notificationsCount(await Get.find<NotificationService>().fetchNotificationsCount());
  }

  setUpFCM() {
    getFCMToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      getFCMToken();
    });
  }

  getFCMToken() {
    FirebaseMessaging.instance.getToken().then((fcmToken) {
      this.fcmToken = fcmToken;
      if (authenticationState.value == AuthenticationState.real) updateFCMToken(fcmToken: fcmToken);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showNotification(message);
      });
    });
  }

  unsubscribeFromLanguageNotifications(List<String> languagesCodes) => languagesCodes.forEach((element) {
        FirebaseMessaging.instance.unsubscribeFromTopic('topic_$element');
      });

  subscribeToGeneralLanguageNotifications(String languageCode) => FirebaseMessaging.instance.subscribeToTopic('topic_$languageCode');

  Future createNotificationChannels() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. notification_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');

    InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) {
      Map<String, dynamic> data = json.decode(payload) as Map;
      if (data.containsKey('product'))
        Get.to(
          () => ChangeNotifierProvider(
            create: (ctx) => ProductDetailsProvider(int.parse(data['product'].toString())),
            child: ProductDetailsScreen(),
          ),
          preventDuplicates: false,
        );
      else if (data['category'] != null || data['brands'] != null || data['gender'] != null || data['sort'] != null)
        Get.to(
            () => ChangeNotifierProvider(
                  create: (_) =>
                      SearchProvider(initialDataParameters: DataParameters.fromNotificationDataJson(data), pageTitle: data['title']),
                  child: SearchScreen(),
                ),
            preventDuplicates: false);
      else if (data['order'] != null)
        Get.to(
            () => ChangeNotifierProvider(
                  create: (ctx) => OrderDetailsProvider(int.parse(data['order'])),
                  child: OrderDetailsScreen(),
                ),
            preventDuplicates: false);
      else if (data['review'] != null)
        Get.to(() => ReviewsScreen(), preventDuplicates: false);
      else {
        Get.find<MainScreenController>().currentIndex = 0;
        Get.until((route) => route.settings.name == '/main');
      }
      return;
    });

    // Create Announcement Channel
    announcementChannel = AndroidNotificationChannel(
      'announcements', // id
      'Announcements', // title
      '', // description
      importance: Importance.defaultImportance,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(announcementChannel);
    // Create Campaigns Channel
    campaignsChannel = AndroidNotificationChannel(
      'campaigns', // id
      'Campaigns', // title
      '', // description
      importance: Importance.defaultImportance,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(campaignsChannel);
    // Create Orders Channel
    ordersChannel = AndroidNotificationChannel(
      'orders', // id
      'Orders', // title
      '', // description
      importance: Importance.defaultImportance,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(ordersChannel);
  }

  showNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    Map<String, dynamic> data = message.data;
    AndroidNotification android = message.notification?.android;
    AndroidNotificationChannel channel;
    if (notification != null && android != null) {
      // Select notification channel
      if (data['product'] != null ||
          data['category'] != null ||
          data['brands'] != null ||
          data['gender'] != null ||
          data['sort'] != null) {
        channel = campaignsChannel;
      } else if (data['order'] != null) {
        channel = ordersChannel;
      } else {
        channel = announcementChannel;
      }
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            icon: android?.smallIcon,
          ),
        ),
        payload: json.encode(message.data..addAll({'title': message.notification.title})),
      );
    }
  }

  onNotificationTapped(int product, int category, List<int> brands, int gender, int sort) {
    if (product != null)
      Get.to(() => ChangeNotifierProvider(
            create: (_) => ProductDetailsProvider(product),
            child: ProductDetailsScreen(),
          ));
  }

  bool get isAuthenticated =>
      authenticationState.value == AuthenticationState.anonymous || authenticationState.value == AuthenticationState.real;

  Future signInAnonymously() async {
    UserCredential credential = await FirebaseAuth.instance.signInAnonymously();
    firebaseToken = await credential.user.getIdToken();
    bool isSuccessful = await Get.find<RemoteUserService>().loginAnonymous();
    if (!isSuccessful) throw Exception();
  }

  Future<bool> checkIsUserExist(String phoneNumber) async {
    try {
      return await Get.find<RemoteUserService>().checkIsExist(phoneNumber);
    } catch (ex) {
      throw ex;
    }
  }

  redirectToLogin({Function onSuccessfulLogin}) => Get.to(
        () => ChangeNotifierProvider(
          create: (ctx) => AuthenticationProvider(onSuccessfulLogin: onSuccessfulLogin),
          child: AuthenticationScreen(),
        ),
      );

  Future editProfile(String name, int genderId) async {
    try {
      await Get.find<RemoteUserService>().editProfile(name, genderId);
    } catch (ex) {
      throw ex;
    }
  }

  Future verifyPhoneNumber({String phoneNumber, Function(String, int) onCodeSent, int resendToken}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyCodeAndSignIn(String verificationId, String code) async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      // Sign the user in (or link) with the credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }

  Future loginToShopizy({String name, String anonymousUserId}) async {
    await Get.find<RemoteUserService>().login(name, anonymousUserId);
  }

  Future updateFCMToken({String fcmToken}) async {
    await Get.find<RemoteUserService>().updateFCMToken(fcmToken);
  }
}

enum AuthenticationState { unauthenticated, anonymous, real }
