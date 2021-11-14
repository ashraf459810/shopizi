import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shopizy/main.dart';

class WelcomeCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: ['بەخێربێیت', 'أهلاً بك', 'Welcome']
          .map(
            (e) =>
                Text(e, textAlign: TextAlign.center, style: appTheme.textStyles.h2.copyWith(fontWeight: appTheme.textStyles.medium)),
          )
          .toList(),
      options: CarouselOptions(
        height: 40,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayCurve: Curves.decelerate,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
