import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppColors colors = AppColors();
  AppTextStyles textStyles = AppTextStyles();

  ThemeData getTheme(BuildContext context) {
    return ThemeData(
      fontFamily: 'Helvetica',
      primaryColor: colors.orange,
      scaffoldBackgroundColor: colors.backgroundColor,
    );
  }
}
