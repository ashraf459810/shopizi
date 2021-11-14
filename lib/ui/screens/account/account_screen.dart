import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/providers/user_provider.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/addresses/addresses_provider.dart';
import 'package:shopizy/ui/screens/addresses/addresses_screen.dart';
import 'package:shopizy/ui/screens/contact_us/contact_us_screen.dart';
import 'package:shopizy/ui/screens/languages/change_language_screen.dart';
import 'package:shopizy/ui/screens/languages/languages_provider.dart';
import 'package:shopizy/ui/screens/notifications/notifications_provider.dart';
import 'package:shopizy/ui/screens/notifications/notifications_screen.dart';
import 'package:shopizy/ui/screens/orders/orders_provider.dart';
import 'package:shopizy/ui/screens/orders/orders_screen.dart';
import 'package:shopizy/ui/screens/profile/profile_provider.dart';
import 'package:shopizy/ui/screens/profile/profile_screen.dart';
import 'package:shopizy/ui/screens/reviews/reviews_screen.dart';
import 'package:shopizy/ui/screens/static/static_screen.dart';

import '../base_screen.dart';

class AccountScreen extends BaseScreen {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    print('Build Account Screen');
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Obx(() => ListView(
              children: [
                Image.asset('assets/images/app_logo.png', height: 150),
                if (UserController.instance.authenticationState.value != AuthenticationState.real)
                  listItem(
                    title: FlutterI18n.translate(context, 'login'),
                    icon: Icons.login,
                    onPressed: () => UserController.instance.redirectToLogin(onSuccessfulLogin: () {
                      Get.back();
                      Get.back();
                    }),
                  ),
                if (UserController.instance.authenticationState.value == AuthenticationState.real)
                  listItem(
                    title: FlutterI18n.translate(context, 'profile'),
                    icon: Icons.person,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ChangeNotifierProvider(
                          create: (ctx) => ProfileProvider(),
                          child: ProfileScreen(),
                        ),
                      ),
                    ),
                  ),
                listItem(
                    title: FlutterI18n.translate(context, 'language'),
                    icon: Icons.language,
                    onPressed: () {
                      Get.to(() => ChangeNotifierProvider(
                            create: (ctx) => LanguagesProvider(),
                            child: ChangeLanguageScreen(),
                          ));
                    }),
                if (UserController.instance.authenticationState.value == AuthenticationState.real)
                  listItem(
                    title: FlutterI18n.translate(context, 'addresses'),
                    icon: Icons.location_on,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ChangeNotifierProvider(
                          create: (ctx) => AddressesProvider(),
                          child: AddressesScreen(),
                        ),
                      ),
                    ),
                  ),
                listItem(
                  title: FlutterI18n.translate(context, 'notifications'),
                  icon: Icons.notifications,
                  onPressed: () => Get.to(
                    () => ChangeNotifierProvider(
                      create: (ctx) => NotificationsProvider(),
                      child: NotificationsScreen(),
                    ),
                  ),
                ),
                if (UserController.instance.authenticationState.value == AuthenticationState.real)
                  listItem(
                      title: FlutterI18n.translate(context, 'orderhistory'),
                      icon: Icons.history_outlined,
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => ChangeNotifierProvider(
                                create: (ctx) => OrdersProvider(),
                                child: OrdersScreen(),
                              ),
                            ),
                          )),
                if (UserController.instance.authenticationState.value == AuthenticationState.real)
                  listItem(
                      title: FlutterI18n.translate(context, 'reviews'),
                      icon: Icons.rate_review_outlined,
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => ReviewsScreen()),
                          )),
                listItem(
                    title: FlutterI18n.translate(context, 'aboutus'),
                    icon: Icons.info_outline,
                    onPressed: () {
                      Get.to(() => StaticScreen(
                            title: FlutterI18n.translate(context, 'aboutus'),
                            pageName: 'about-us',
                          ));
                    }),
                listItem(
                    title: FlutterI18n.translate(context, 'contactus'),
                    icon: Icons.support_agent_rounded,
                    onPressed: () {
                      Get.to(() => ContactUsScreen());
                    }),
                listItem(
                    title: FlutterI18n.translate(context, 'termsandconditions'),
                    icon: Icons.list_alt,
                    onPressed: () {
                      Get.to(() => StaticScreen(
                            title: FlutterI18n.translate(context, 'termsandconditions'),
                            pageName: 'terms-and-conditions',
                          ));
                    }),
                listItem(
                    title: FlutterI18n.translate(context, 'deliveryinformation'),
                    icon: Icons.delivery_dining,
                    onPressed: () {
                      Get.to(() => StaticScreen(
                            title: FlutterI18n.translate(context, 'deliveryinformation'),
                            pageName: 'delivery-information',
                          ));
                    }),
                listItem(
                    title: FlutterI18n.translate(context, 'faq'),
                    icon: Icons.contact_support_outlined,
                    onPressed: () {
                      Get.to(() => StaticScreen(
                            title: FlutterI18n.translate(context, 'faq'),
                            pageName: 'faq',
                          ));
                    }),
                if (UserController.instance.authenticationState.value == AuthenticationState.real)
                  listItem(
                    title: FlutterI18n.translate(context, 'logout'),
                    icon: Icons.exit_to_app,
                    onPressed: () => userProvider.logout(),
                    color: Colors.red,
                  ),
              ],
            )),
      ),
    );
  }

  listItem({String title, IconData icon, Function onPressed, Color color}) {
    return ListTile(
      onTap: onPressed,
      title: Text(title, style: TextStyle(color: color ?? Colors.black)),
      leading: Icon(icon, color: color ?? Colors.grey[500]),
    );
  }
}
