import 'package:flutter/material.dart';

class AppShapes {
  static BoxDecoration roundedRectDecoration({
    double radius = 4,
    Color color = Colors.white,
    Color borderColor = Colors.transparent,
    String backgroundImage,
    double borderWidth = 1,
  }) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(color: borderColor, width: borderColor != Colors.transparent ? borderWidth : 0),
        color: color,
        image: backgroundImage != null
            ? DecorationImage(
                image: NetworkImage(backgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.grey[600], BlendMode.multiply))
            : null);
  }

  static BoxDecoration fullyRoundedRectDecoration({Color color = Colors.white, Color borderColor = Colors.transparent}) {
    return roundedRectDecoration(radius: 50, borderColor: borderColor, color: color);
  }

  static RoundedRectangleBorder roundedRectShape({double radius = 4, Color borderColor = Colors.transparent}) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius)), side: BorderSide(color: borderColor));
  }

  static RoundedRectangleBorder fullyRoundedRectShape({Color borderColor = Colors.transparent}) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)), side: BorderSide(color: borderColor));
  }

  static BoxDecoration circleDecoration({Color color = Colors.white, Color borderColor = Colors.transparent, double borderWidth = 1}) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: borderColor, width: borderWidth),
      shape: BoxShape.circle,
    );
  }
}
