import 'package:flutter/material.dart';
import 'package:shopizy/main.dart';

class RatingBar extends StatelessWidget {
  final int averageRate;
  final int rateCount;

  RatingBar(this.averageRate, {this.rateCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= averageRate; i++) Icon(Icons.star, color: Colors.yellow[700], size: 14),
        for (int i = 1; i <= (5 - averageRate); i++) Icon(Icons.star_border, color: Colors.yellow[700], size: 14),
        if (rateCount != null)
          Text(
            '  ($rateCount)',
            style: appTheme.textStyles.subtitle4.copyWith(color: appTheme.colors.darkGrey),
          ),
      ],
    );
  }
}
