import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/ui/screens/login/authentication_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/global_style.dart';
import 'package:shopizy/ui/widgets/custom_text_field.dart';

import '../base_screen.dart';

// ignore: must_be_immutable
class AuthenticationScreen extends BaseScreen {
  AuthenticationProvider provider;

  @override
  Widget body(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(30, 120, 30, 30),
            children: <Widget>[
              Container(child: Image.asset('assets/images/app_logo.png', height: 150)),
              SizedBox(height: 15),
              Text(FlutterI18n.translate(context, 'phonenumber'), style: GlobalStyle.authTitle),
              SizedBox(height: 8),
              phoneField(),
              if (provider.isNewUser ?? false) nameField(context, provider.nameController, provider.nameFocusNode),
              SizedBox(height: 40),
              Container(
                height: 45,
                child: provider.loading
                    ? loading()
                    : provider.isNewUser ?? false
                        ? registerButton(context)
                        : loginButton(context),
              ),
            ],
          ),
          PositionedDirectional(
            top: 16,
            start: 16,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: Colors.grey[400], size: 30),
            ),
          )
        ],
      ),
    );
  }

  phoneField() => Directionality(
        textDirection: TextDirection.ltr,
        child: CustomTextField(
          controller: provider.phoneController,
          textStyle: TextStyle(fontSize: 16),
          keyboardType: TextInputType.phone,
          textInputFormatters: [LengthLimitingTextInputFormatter(10)],
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IntrinsicWidth(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 6),
                  Text('+964', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ),
          prefixTextStyle: TextStyle(fontSize: 16, color: Colors.black),
          hint: '750XXXXXXX',
        ),
      );

  nameField(BuildContext ctx, TextEditingController controller, FocusNode focusNode) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(FlutterI18n.translate(ctx, 'fullname'), style: GlobalStyle.authTitle),
          SizedBox(height: 8),
          CustomTextField(
            controller: controller,
            hint: FlutterI18n.translate(ctx, 'typeyourname'),
            textStyle: TextStyle(fontSize: 16),
            padding: EdgeInsets.symmetric(horizontal: 24),
            focusNode: focusNode,
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.person),
            ),
          ),
        ],
      );

  loading() => Container(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
          ),
        ),
      );

  loginButton(BuildContext context) => TextButton(
        onPressed: () => provider.checkIsUserExistAndRedirect(),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.PRIMARY_COLOR)),
        child: Text(
          FlutterI18n.translate(context, 'login'),
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );

  registerButton(BuildContext context) => TextButton(
        onPressed: () => provider.register(),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.PRIMARY_COLOR)),
        child: Text(
          FlutterI18n.translate(context, 'register'),
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
}
