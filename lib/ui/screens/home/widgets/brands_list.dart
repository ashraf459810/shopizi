import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/brand.dart';
import 'package:shopizy/ui/enum/list_item_location.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';
import 'package:shopizy/utils/list_extensions.dart';

class BrandsList extends StatelessWidget {
  final List<Brand> brands;

  BrandsList(this.brands);

  @override
  Widget build(BuildContext context) {
    return brands.isNotEmpty
        ? Container(
            height: 75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              itemBuilder: (ctx, index) => listItem(
                  context, brands[index], brands.getItemLocation(index)),
            ),
          )
        : SizedBox();
  }

  Widget listItem(
      BuildContext context, Brand brand, ListItemLocation location) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider(
            create: (_) => SearchProvider(
                initialDataParameters: brand.dataParameters,
                pageTitle: brand.name),
            child: SearchScreen(),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: location == ListItemLocation.first ? 12 : 8),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
                width: 75, height: 75, imageUrl: brand.picturePath)),
      ),
    );
  }
}
