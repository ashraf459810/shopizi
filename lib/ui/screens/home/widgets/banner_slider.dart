import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/banner_model.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;

  BannerSlider(this.banners);

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.banners
              .map(
                (banner) => GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ChangeNotifierProvider(
                            create: (_) => SearchProvider(initialDataParameters: banner.data, pageTitle: banner.name),
                            child: SearchScreen(),
                          ))),
                  child: Container(
                      child: CachedNetworkImage(
                    imageUrl: banner.picturePath,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      child: Shimmer.fromColors(
                        child: Container(color: Colors.grey[200]),
                        baseColor: Colors.grey[200],
                        highlightColor: Colors.white,
                      ),
                    ),
                  )),
                ),
              )
              .toList(),
          options: CarouselOptions(
              aspectRatio: 8 / 4,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 500),
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              }),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.banners.map((item) {
              int index = widget.banners.indexOf(item);
              return Container(
                width: 20.0,
                height: 2.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: AppShapes.roundedRectDecoration(
                  color: _currentIndex == index ? appTheme.colors.orange : Colors.grey[300],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
