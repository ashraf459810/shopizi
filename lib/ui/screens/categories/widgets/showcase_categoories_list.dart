import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/category.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/settings/storage_keys.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

class ShowcaseCategoriesList extends StatefulWidget {
  final List<Category> categories;

  ShowcaseCategoriesList(this.categories);

  @override
  _ShowcaseCategoriesListState createState() => _ShowcaseCategoriesListState();
}

class _ShowcaseCategoriesListState extends State<ShowcaseCategoriesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          key: UniqueKey(),
          expandedHeaderPadding: EdgeInsets.zero,
          animationDuration: Duration(milliseconds: 500),
          elevation: 0,
          initialOpenPanelValue: widget.categories.first,
          dividerColor: Colors.grey.withOpacity(0.1),
          expansionCallback: (int index, bool isExpanded) {},
          children: [
            ...widget.categories.map(
              (category) => ExpansionPanelRadio(
                value: category,
                canTapOnHeader: true,
                headerBuilder: (ctx, isExpanded) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    category.name,
                    style: appTheme.textStyles.subtitle1.copyWith(
                        color: isExpanded ? appTheme.colors.orange : appTheme.colors.black, fontWeight: appTheme.textStyles.medium),
                  ),
                ),
                body: Container(
                  child: GridView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.68,
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    children: [
                      ...category.children.map(
                        (e) {
                          bool hasPicture = e.picturePath != null;
                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ChangeNotifierProvider(
                                  create: (_) => SearchProvider(initialDataParameters: e.dataParameters, pageTitle: e.name),
                                  child: SearchScreen(),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: AppShapes.roundedRectDecoration(
                                      radius: 6, borderColor: hasPicture ? Colors.grey[200] : Colors.transparent),
                                  child: hasPicture
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: CachedNetworkImage(height: 90, imageUrl: e.picturePath, fit: BoxFit.cover))
                                      : SizedBox(height: 90),
                                ),
                                SizedBox(height: 4),
                                Text(e.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: appTheme.textStyles.subtitle3)
                              ],
                            ),
                          );
                        },
                      ),
                      // See ALL
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ChangeNotifierProvider(
                              create: (_) => SearchProvider(
                                initialDataParameters: DataParameters(categoryId: category.id, genderId: category.genderId),
                                pageTitle: category.name,
                              ),
                              child: SearchScreen(),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: AppShapes.roundedRectDecoration(radius: 6, borderColor: Colors.transparent),
                              height: 90,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(GetStorage().read(StorageKeys.language) == 'en'
                                    ? 'assets/images/right_arrow.png'
                                    : 'assets/images/left_arrow.png'),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(FlutterI18n.translate(context, 'seeall'),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: appTheme.textStyles.subtitle3)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
