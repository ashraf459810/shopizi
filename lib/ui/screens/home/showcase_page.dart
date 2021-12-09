import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/banner_model.dart';
import 'package:shopizy/models/brand.dart';
import 'package:shopizy/models/category.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/services/global_services/showcase_service.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/screens/search/search_screen.dart';

import 'widgets/banner_list.dart';
import 'widgets/banner_slider.dart';
import 'widgets/brands_list.dart';
import 'widgets/featured_categories_grid.dart';
import 'widgets/featured_products_list.dart';

class ShowcasePage extends StatefulWidget {
  final int showcaseId;
  final String showcaseName;

  ShowcasePage(this.showcaseId, this.showcaseName);

  @override
  _ShowcasePageController createState() => _ShowcasePageController();
}

class _ShowcasePageController extends State<ShowcasePage>
    with AutomaticKeepAliveClientMixin<ShowcasePage> {
  var sliders = <BannerModel>[];
  var categories = <Category>[];
  var brands = <Brand>[];
  var featuredProducts = <Product>[];
  var banners = <BannerModel>[];
  bool isLoading = true;

  @override
  void initState() {
    Get.find<ShowcaseService>()
        .fetchShowcaseContent(widget.showcaseId)
        .then((showcaseContent) {
      setState(() {
        isLoading = false;
        sliders = showcaseContent.sliders;
        categories = showcaseContent.categories;
        brands = showcaseContent.brands;
        featuredProducts = showcaseContent.featuredProducts;
        banners = showcaseContent.banners;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _ShowcasePageView(this);
  }

  @override
  bool get wantKeepAlive => true;

  bool get isEmptyPage =>
      sliders.isEmpty &&
      categories.isEmpty &&
      brands.isEmpty &&
      featuredProducts.isEmpty &&
      banners.isEmpty;
}

class _ShowcasePageView extends StatelessWidget {
  final _ShowcasePageController state;

  ShowcasePage get widget => state.widget;

  const _ShowcasePageView(this.state);

  Widget build(BuildContext context) {
    return state.isLoading
        ? Container()
        : state.isEmptyPage
            ? emptyState()
            : CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        BannerSlider(state.sliders),
                        sectionTitle(FlutterI18n.translate(
                            context, "featuredcategories")),
                        FeaturedCategoriesGrid(state.categories),
                        state.brands.isNotEmpty
                            ? sectionTitle(
                                FlutterI18n.translate(context, "popularbrands"))
                            : SizedBox(),
                        BrandsList(state.brands),
                        featuredProductsTitle(context),
                        FeaturedProductsList(state.featuredProducts),
                        SizedBox(height: 6),
                        BannerList(state.banners),
                      ],
                    ),
                  ),
                ],
              );
  }

  emptyState() => Container(
        alignment: Alignment.center,
        child: Text('No data',
            style: appTheme.textStyles.subtitle1
                .copyWith(color: Colors.grey[400])),
      );

  sectionTitle(title) => Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 12, top: 24, bottom: 12),
        child: Text(title,
            style: appTheme.textStyles.subtitle1
                .copyWith(fontWeight: appTheme.textStyles.bold)),
      );

  featuredProductsTitle(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
            start: 12, top: 24, end: 16, bottom: 12),
        child: Row(
          children: [
            Text(FlutterI18n.translate(context, "featuredProducts"),
                style: appTheme.textStyles.subtitle1
                    .copyWith(fontWeight: appTheme.textStyles.bold)),
            Spacer(),
            GestureDetector(
              onTap: () => Get.to(() => ChangeNotifierProvider(
                    create: (_) => SearchProvider(
                      pageTitle: widget.showcaseName,
                      initialDataParameters: DataParameters(
                          showcase: widget.showcaseId, sortBy: 13),
                    ),
                    child: SearchScreen(),
                  )),
              child: Text(FlutterI18n.translate(context, "viewall"),
                  style: appTheme.textStyles.subtitle2
                      .copyWith(color: appTheme.colors.orange)),
            ),
          ],
        ),
      );
}
