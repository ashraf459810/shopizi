import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/providers/user_provider.dart';
import 'package:shopizy/ui/screens/login/mobile_verification_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/theme/global_style.dart';

// ignore: must_be_immutable
class MobileVerificationScreen extends StatelessWidget {
  MobileVerificationProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
        body: Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(30, 120, 30, 30),
          children: <Widget>[
            Icon(Icons.phone_android, color: AppColors.PRIMARY_COLOR, size: 70),
            SizedBox(height: 40),
            Center(
                child: Text(
              FlutterI18n.translate(context, 'codesent'),
              style: GlobalStyle.chooseVerificationTitle,
              textAlign: TextAlign.center,
            )),
            SizedBox(height: 20),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: PinCodeTextField(
                  autoFocus: true,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  length: 6,
                  showCursor: false,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveColor: AppColors.SOFT_GREY,
                      activeColor: AppColors.PRIMARY_COLOR,
                      selectedColor: AppColors.PRIMARY_COLOR),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  onChanged: (value) {
                    provider.code = value;
                    provider.isCodeComplete = value.length == 6;
                  },
                  beforeTextPaste: (text) {
                    return false;
                  },
                ),
              ),
            ),
            if (provider.errMessage != null)
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: AppShapes.roundedRectDecoration(borderColor: Colors.red, color: Colors.transparent),
                child: Text(
                  provider.errMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 60),
            Container(
                width: double.infinity,
                child: provider.isLoading
                    ? Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          verifyButton(context),
                          if (provider.showResendButton) resendButton(context),
                        ],
                      )),
          ],
        ),
        PositionedDirectional(
          top: 40,
          start: 16,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Colors.grey[400], size: 30),
          ),
        )
      ],
    ));
  }

  verifyButton(BuildContext context) => Container(
        height: 50,
        child: TextButton(
          onPressed: provider.isVerificationButtonEnabled
              ? () {
                  provider.toggleLoading();
                  provider.hideErrorMessage();
                  Provider.of<UserProvider>(context, listen: false).verify(provider.verificationId, provider.code, provider.name, () {
                    provider.toggleLoading();
                    provider.onSuccessfulAuthentication();
                  }, () {
                    provider.toggleLoading();
                    provider.showErrorMessage(FlutterI18n.translate(context, 'verificationcodeiswrong'));
                  });
                }
              : null,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => provider.isVerificationButtonEnabled ? AppColors.PRIMARY_COLOR : Colors.grey[300])),
          child: Text(
            FlutterI18n.translate(context, 'verify'),
            style: TextStyle(fontSize: 18, color: provider.isVerificationButtonEnabled ? Colors.white : Colors.grey[500]),
          ),
        ),
      );

  resendButton(BuildContext context) => Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextButton(
          onPressed: () => provider.sendVerificationSMS(),
          style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith(
              (states) => AppShapes.roundedRectShape(borderColor: AppColors.PRIMARY_COLOR),
            ),
          ),
          child: Text(
            FlutterI18n.translate(context, 'resend'),
            style: TextStyle(fontSize: 18, color: AppColors.PRIMARY_COLOR),
          ),
        ),
      );
}
