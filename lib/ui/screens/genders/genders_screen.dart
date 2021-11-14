import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/gender.dart';
import 'package:shopizy/settings/storage_keys.dart';
import 'package:shopizy/ui/screens/genders/genders_provider.dart';
import 'package:shopizy/ui/screens/main/main_screen.dart';

import '../base_screen.dart';
import 'widgets/genders_list.dart';

class GendersScreen extends BaseScreen {
  @override
  Widget body(BuildContext context) {
    GendersProvider provider = Provider.of(context);
    return provider.genders == null
        ? Container()
        : Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(FlutterI18n.translate(context, "selectgender"),
                      style: appTheme.textStyles.h2.copyWith(fontWeight: appTheme.textStyles.bold)),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GendersList(
                      provider.genders,
                      (Gender selectedGender) {
                        GetStorage().write(StorageKeys.genderId, selectedGender.id);
                        Get.off(
                          () => MainScreen(),
                          binding: BindingsBuilder(() {
                            Get.put(MainScreenController());
                          }),
                        );
                      },
                      null,
                    ),
                  ),
                ],
              ),
              PositionedDirectional(bottom: 24, end: 24, child: skip(context)),
            ],
          );
  }

  skip(BuildContext ctx) => FlatButton(
        onPressed: () => Get.off(() => MainScreen(), binding: BindingsBuilder(() {
          Get.put(MainScreenController());
        })),
        child: Row(
          children: [
            Text(
              FlutterI18n.translate(ctx, "skip"),
              style: appTheme.textStyles.subtitle3.copyWith(color: appTheme.colors.midGrey),
            ),
          ],
        ),
      );
}
