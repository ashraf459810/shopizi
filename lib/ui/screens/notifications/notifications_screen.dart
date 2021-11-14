import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/models/notification.dart';
import 'package:shopizy/services/global_services/notification_service.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/login/authentication_provider.dart';
import 'package:shopizy/ui/screens/login/authentication_screen.dart';
import 'package:shopizy/ui/screens/main/main_screen.dart';
import 'package:shopizy/ui/screens/notifications/notifications_provider.dart';
import 'package:shopizy/ui/screens/order_details/order_details_provider.dart';
import 'package:shopizy/ui/screens/order_details/order_details_screen.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/screens/reviews/reviews_screen.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<NotificationService>().setViewed().then((value) => Get.find<UserController>().notificationsCount(0));
  }

  Widget appBar(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        centerTitle: true,
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'notifications'),
          style: TextStyle(color: Colors.black),
        ),
      );

  @override
  Widget build(BuildContext context) {
    NotificationsProvider provider = Provider.of(context);
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: UserController.instance.authenticationState.value != AuthenticationState.real
            ? unauthenticatedState(context)
            : provider.loading
                ? Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                      ),
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (ctx, index) => Divider(),
                    itemCount: provider.notifications.length,
                    itemBuilder: (ctx, index) => notificationItem(provider.notifications[index]),
                  ),
      ),
    );
  }

  notificationItem(Notification notification) {
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> data = notification.data;
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
                    create: (_) => SearchProvider(
                        initialDataParameters: DataParameters.fromNotificationDataJson(data), pageTitle: notification.title),
                    child: SearchScreen(),
                  ),
              preventDuplicates: false);
        else if (data['order'] != null)
          Get.to(
              () => ChangeNotifierProvider(
                    create: (ctx) => OrderDetailsProvider(data['order']),
                    child: OrderDetailsScreen(),
                  ),
              preventDuplicates: false);
        else if (data['review'] != null)
          Get.to(() => ReviewsScreen(), preventDuplicates: false);
        else {
          Get.find<MainScreenController>().currentIndex = 0;
          Get.until((route) => route.settings.name == '/main');
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              notification.title,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              notification.updatedAt,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            SizedBox(height: 8),
            Text(notification.body,
                style: TextStyle(fontSize: 17, color: [2, 3, 5].contains(notification.type) ? Color(0xffef7f11) : Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  unauthenticatedState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Text(FlutterI18n.translate(context, 'logintocontinue')),
        SizedBox(height: 12),
        Container(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => ChangeNotifierProvider(
                    create: (ctx) => AuthenticationProvider(onSuccessfulLogin: () {
                      //favoriteController.fetchFavoritesPage(fromStart: true);
                    }),
                    child: AuthenticationScreen(),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(horizontal: 36)),
              backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.PRIMARY_COLOR),
            ),
            child: Text(
              FlutterI18n.translate(context, 'login'),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}
