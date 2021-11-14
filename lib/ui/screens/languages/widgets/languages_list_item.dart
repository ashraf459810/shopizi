import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/language.dart';
import 'package:shopizy/settings/storage_keys.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

class LanguagesListItem extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final Function(Language) onLanguageSelected;
  final bool showHelpText;
  final bool showLoading;

  LanguagesListItem({this.language, this.isSelected, this.onLanguageSelected, this.showHelpText, this.showLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShapes.roundedRectDecoration(
        borderColor: isSelected ? appTheme.colors.orange : appTheme.colors.orange.withOpacity(0.5),
        color: isSelected ? AppColors.PRIMARY_COLOR.withOpacity(0.2) : Colors.transparent,
        radius: 8,
      ),
      margin: EdgeInsets.only(top: 12),
      height: 60,
      child: InkWell(
        onTap: () async {
          // Save preference
          await GetStorage().write(StorageKeys.language, language.key);
          Get.updateLocale(Locale(language.key));
          onLanguageSelected(language);
        },
        borderRadius: BorderRadius.circular(8),
        highlightColor: appTheme.colors.orange.withOpacity(0.7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 16),
            Text(showHelpText ? language.helpText : language.title),
            SizedBox(width: 12),
            Spacer(),
            if (showLoading)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                ),
              )
          ],
        ),
      ),
    );
  }

  flag(String flag) => Container(
        width: 50,
        margin: EdgeInsetsDirectional.only(start: 12),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(flag, fit: BoxFit.cover),
        ),
      );
}
