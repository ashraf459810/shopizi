import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/ui/screens/edit_profile/edit_profile_provider.dart';
import 'package:shopizy/ui/screens/edit_profile/edit_profile_screen.dart';
import 'package:shopizy/ui/screens/profile/profile_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'profile'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: 120,
            height: 120,
            margin: EdgeInsets.only(top: 60),
            alignment: Alignment.center,
            decoration: AppShapes.circleDecoration(borderColor: AppColors.PRIMARY_COLOR),
            child: Image.asset('assets/images/user.png', height: 60, color: AppColors.PRIMARY_COLOR),
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            decoration: AppShapes.roundedRectDecoration(radius: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText(FlutterI18n.translate(context, 'fullname'), Icons.person),
                valueText(provider.name),
                SizedBox(height: 14),
                titleText(FlutterI18n.translate(context, 'phonenumber'), Icons.phone_android),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: valueText(provider.phoneNumber),
                ),
                SizedBox(height: 14),
                titleText(FlutterI18n.translate(context, 'genderchoice'), Icons.check_box_outlined),
                valueText(
                  GetStorage().read('genderId') == null
                      ? 'Not provided'
                      : GetStorage().read('genderId') == 1008
                          ? FlutterI18n.translate(context, 'men')
                          : FlutterI18n.translate(context, 'women'),
                ),
              ],
            ),
          ),
          Container(
            height: 55,
            margin: EdgeInsets.all(20),
            child: TextButton(
              onPressed: () => Get.to(
                () => ChangeNotifierProvider(
                  create: (ctx) => EditProfileProvider(),
                  child: EditProfileScreen(),
                ),
              ).then((value) => provider.notify()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith((states) => AppShapes.roundedRectShape(radius: 8)),
                  backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.PRIMARY_COLOR)),
              child: Text(FlutterI18n.translate(context, 'editprofile'), style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  titleText(String title, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.PRIMARY_COLOR, size: 20),
            SizedBox(width: 6),
            Text(title, style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );

  valueText(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Text(text ?? '', style: TextStyle(fontSize: 17)),
      );
}
