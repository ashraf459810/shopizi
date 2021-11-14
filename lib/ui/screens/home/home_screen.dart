import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/home/home_controller.dart';
import 'package:shopizy/ui/screens/notifications/notifications_provider.dart';
import 'package:shopizy/ui/screens/notifications/notifications_screen.dart';
import 'package:shopizy/ui/screens/search/search_expression_provider.dart';
import 'package:shopizy/ui/screens/search/search_expression_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

class HomeScreen extends StatelessWidget {
  Widget appBar(BuildContext ctx) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: FlatButton(
          splashColor: appTheme.colors.lightGrey,
          highlightColor: appTheme.colors.lightGrey,
          shape: AppShapes.roundedRectShape(radius: 8),
          onPressed: () => Get.to(
            () => ChangeNotifierProvider(
              create: (ctx) => SearchExpressionProvider(),
              child: SearchExpressionScreen(),
            ),
          ),
          color: appTheme.colors.lightGrey,
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[500], size: 18),
              SizedBox(width: 8),
              Text(FlutterI18n.translate(ctx, "searchplaceholder"),
                  style: appTheme.textStyles.subtitle2
                      .copyWith(color: appTheme.colors.midGrey)),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () => Get.to(() => ChangeNotifierProvider(
                  create: (ctx) => NotificationsProvider(),
                  child: NotificationsScreen(),
                )),
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: 12.0),
              child: Obx(
                () => Get.find<UserController>().notificationsCount.value != 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 12),
                        child: Stack(
                          children: [
                            Icon(Icons.notifications,
                                color: appTheme.colors.midGrey, size: 30),
                            PositionedDirectional(
                              end: 0,
                              top: 0,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: AppShapes.circleDecoration(
                                    color: AppColors.PRIMARY_COLOR),
                                child: Text(
                                  Get.find<UserController>()
                                      .notificationsCount
                                      .value
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Icon(Icons.notifications,
                        color: appTheme.colors.midGrey, size: 30),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: appBar(context),
      body: Obx(() {
        return controller.showcaseTabs.isEmpty
            ? Center(
                child: Container(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                  ),
                ),
              )
            : DefaultTabController(
                key: UniqueKey(),
                length: controller.showcaseTabs.length,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: TabBar(
                        isScrollable: true,
                        labelColor: appTheme.colors.orange,
                        labelStyle: appTheme.textStyles.subtitle2
                            .copyWith(fontWeight: appTheme.textStyles.medium),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 1,
                        indicatorColor: appTheme.colors.orange,
                        unselectedLabelColor: appTheme.colors.midGrey,
                        labelPadding: EdgeInsets.symmetric(horizontal: 12),
                        tabs: controller.showcaseTabs,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: controller.showcasePages,
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
