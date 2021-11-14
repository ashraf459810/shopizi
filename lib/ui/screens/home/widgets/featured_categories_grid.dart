import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/category.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';

class FeaturedCategoriesGrid extends StatelessWidget {
  final List<Category> categories;

  FeaturedCategoriesGrid(this.categories);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        primary: false,
        childAspectRatio: 0.55,
        shrinkWrap: true,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 4,
        children: [
          ...categories.map((e) => categoryCell(context, e)),
        ]);
  }

  Widget categoryCell(BuildContext ctx, Category category) {
    return GestureDetector(
      onTap: () => Navigator.of(ctx).push(
        MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider(
            create: (_) => SearchProvider(initialDataParameters: category.dataParameters, pageTitle: category.name),
            child: SearchScreen(),
          ),
        ),
      ),
      child: Container(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                      width: 80, height: 80 * 1.49, imageUrl: '${category.picturePath}?width=80', fit: BoxFit.cover)),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(category.name,
                      style: appTheme.textStyles.subtitle4, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
