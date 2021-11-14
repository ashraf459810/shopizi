import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/gender.dart';
import 'package:shopizy/ui/screens/edit_profile/edit_profile_provider.dart';
import 'package:shopizy/ui/screens/genders/widgets/genders_list.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'editprofile'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: provider.initialLoading
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
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  titleText(FlutterI18n.translate(context, 'fullname')),
                  CustomTextField(
                    controller: provider.nameController,
                    prefixIcon: Icon(Icons.person),
                  ),
                  SizedBox(height: 16),
                  titleText(FlutterI18n.translate(context, 'phonenumber')),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomTextField(
                      enabled: false,
                      controller: provider.phoneController,
                      textStyle: TextStyle(fontSize: 16),
                      keyboardType: TextInputType.phone,
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
                  ),
                  SizedBox(height: 16),
                  titleText(FlutterI18n.translate(context, 'genderchoice')),
                  GendersList(
                    provider.genders,
                    (Gender selectedGender) {
                      provider.selectedGenderId = selectedGender.id;
                      provider.notify();
                    },
                    provider.selectedGenderId,
                    iconSize: 60,
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 45,
                    child: provider.saving
                        ? Container(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () => provider.save(context),
                            style:
                                ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.PRIMARY_COLOR)),
                            child: Text(
                              FlutterI18n.translate(context, 'save'),
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  titleText(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[500],
          ),
        ),
      );
}
