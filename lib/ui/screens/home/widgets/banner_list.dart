import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/banner_model.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';

class BannerList extends StatelessWidget {
  final List<BannerModel> banners;

  BannerList(this.banners);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: banners.length,
      itemBuilder: (ctx, index) => Container(
        margin: EdgeInsets.only(top: 2),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ChangeNotifierProvider(
                create: (_) => SearchProvider(initialDataParameters: banners[index].data, pageTitle: banners[index].name),
                child: SearchScreen(),
              ),
            ),
          ),
          child: Container(child: CachedNetworkImage(imageUrl: banners[index].picturePath, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
