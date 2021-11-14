import 'package:flutter/material.dart';

class AppTextStyles {
  TextStyle h1;
  TextStyle h2;
  TextStyle h3;
  TextStyle subtitle1;
  TextStyle subtitle2;
  TextStyle subtitle3;
  TextStyle subtitle4;
  TextStyle hint;

  AppTextStyles() {
    h1 = TextStyle(fontSize: 18, color: Colors.black);
    h2 = TextStyle(fontSize: 16, color: Colors.black);
    h3 = TextStyle(fontSize: 15, color: Colors.black);
    subtitle1 = TextStyle(fontSize: 14, color: Colors.black);
    subtitle2 = TextStyle(fontSize: 13, color: Colors.black);
    subtitle3 = TextStyle(fontSize: 12, color: Colors.black);
    subtitle4 = TextStyle(fontSize: 11, color: Colors.black);
    hint = TextStyle(fontSize: 12, color: Colors.black);
  }

  FontWeight get regular => FontWeight.w400;

  FontWeight get medium => FontWeight.w500;

  FontWeight get bold => FontWeight.w700;

  FontWeight get extraBold => FontWeight.w900;
}
