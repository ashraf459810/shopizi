import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/filter_module.dart';
import 'package:shopizy/models/price_filter_module.dart';
import 'package:shopizy/models/sort_option.dart';
import 'package:shopizy/ui/screens/home/widgets/product_item.dart';
import 'package:shopizy/ui/screens/search/search_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/utils/double_extensions.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      endDrawer: provider.searchResponse != null
          ? Container(
              color: Colors.white,
              width: 300,
              height: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(FlutterI18n.translate(context, 'filters'),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                TextButton(
                                    onPressed: () =>
                                        provider.loadInitialSearchResults(),
                                    child: Text(
                                        FlutterI18n.translate(context, 'reset'),
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 16)))
                              ],
                            ),
                          ),
                          if (provider.searchResponse.categoryFilterModule !=
                              null)
                            categoriesList(
                                provider.searchResponse.categoryFilterModule),
                          if (provider.searchResponse.brandFilterModule != null)
                            brandCheckboxes(context,
                                provider.searchResponse.brandFilterModule),
                          if (provider.searchResponse.genderFilterModule !=
                              null)
                            genderRadioButtons(
                                provider.searchResponse.genderFilterModule),
                          if (provider.searchResponse.colorFilterModule != null)
                            colorOptions(
                                provider.searchResponse.colorFilterModule),
                          if (provider.searchResponse.attributeFilterModule !=
                              null)
                            ...provider.searchResponse.attributeFilterModule
                                .map((e) =>
                                    singleAttributeCheckboxes(context, e)),
                          if (provider.searchResponse.priceModule != null)
                            priceRangeSlider(
                                context, provider.searchResponse.priceModule),
                        ],
                      ),
                    ),
                  ),
                  showProductsButton(context),
                ],
              ),
            )
          : Container(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(
          provider.pageTitle ?? FlutterI18n.translate(context, 'products'),
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
        actions: <Widget>[
          // to remove drawer icon
          new Container(),
        ],
      ),
      body: provider.initialLoading
          ? Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                ),
              ),
            )
          : provider.searchResponse.totalProducts != 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      Container(
                          height: 1,
                          color: Colors.grey[200],
                          width: double.infinity),
                      Card(
                          child: filterAndSortActions(context),
                          elevation: 4,
                          shadowColor: Colors.grey[100],
                          margin: EdgeInsets.zero),
                      Expanded(
                        child: Stack(
                          children: [
                            ListView.builder(
                              controller: provider.scrollController,
                              padding: EdgeInsets.all(10),
                              itemCount:
                                  (provider.products.length / 2).ceil() + 1,
                              itemBuilder: (ctx, index) => Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: index <
                                        (provider.products.length / 2).ceil()
                                    ? Row(
                                        children: [
                                          ProductItem(
                                            product:
                                                provider.products[index * 2],
                                            itemWidth: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    28) /
                                                2,
                                          ),
                                          SizedBox(width: 8),
                                          if (provider.products.length >
                                              index * 2 + 1)
                                            ProductItem(
                                              product: provider
                                                  .products[index * 2 + 1],
                                              itemWidth: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      28) /
                                                  2,
                                            )
                                        ],
                                      )
                                    : provider.products.length !=
                                            provider.totalProducts
                                        ? Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        AppColors
                                                            .PRIMARY_COLOR),
                                              ),
                                            ),
                                          )
                                        : Container(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                          height: 100,
                          child: Text(
                            FlutterI18n.translate(context, "emptyproductlist"),
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                    ),
                  ],
                ),
    );
  }

  filterAndSortActions(BuildContext context) => Row(
        children: [
          Expanded(
              child: actionButton(
                  FlutterI18n.translate(context, 'sort'), Icons.sort_by_alpha,
                  () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.grey[100],
              builder: (ctx) {
                return Wrap(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: provider.searchResponse.sortModule.length,
                      itemBuilder: (ctx, index) {
                        SortOption option =
                            provider.searchResponse.sortModule[index];
                        return GestureDetector(
                          onTap: () => provider.setSortOption(option.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6),
                            child: Row(
                              children: [
                                option.id == provider.searchParameters.sort
                                    ? Icon(Icons.radio_button_checked_rounded,
                                        color: AppColors.PRIMARY_COLOR)
                                    : Icon(
                                        Icons.radio_button_off,
                                        color: Colors.grey[300],
                                      ),
                                SizedBox(width: 8),
                                Text(option.name),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]);
              },
            );
          })),
          Container(width: 1, color: Colors.grey[200], height: 50),
          Expanded(
            child: Builder(
                builder: (ctx) => actionButton(
                    FlutterI18n.translate(context, 'filter'),
                    Icons.filter_alt_outlined,
                    () => Scaffold.of(ctx).openEndDrawer())),
          ),
        ],
      );

  actionButton(String title, IconData icon, Function onPressed) =>
      GestureDetector(
        onTap: onPressed,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.PRIMARY_COLOR),
              SizedBox(width: 12),
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );

  Widget categoriesList(FilterModule filterModule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(filterModule.name),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.parentCategories.isNotEmpty)
              ...provider.parentCategories.map((parentCategory) => InkWell(
                    onTap: () {
                      provider.searchParameters.categoryId = parentCategory.id;
                      provider.search(clearPreviousResults: true);
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 6, right: 6),
                      child: Text('${parentCategory.name}',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  )),
            ...filterModule.filterModuleItems.map(
              (category) => Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () {
                        provider.searchParameters.categoryId = category.id;
                        provider.search(clearPreviousResults: true);
                      },
                      child: Container(
                        padding: provider.parentCategories.isNotEmpty
                            ? EdgeInsetsDirectional.only(
                                start: 18, end: 10, top: 20)
                            : const EdgeInsets.only(top: 20, left: 6, right: 6),
                        child: Row(
                          children: [
                            Text('${category.name}',
                                style: TextStyle(
                                    color: category.isSelected
                                        ? AppColors.PRIMARY_COLOR
                                        : Colors.black,
                                    fontSize: 16)),
                            Spacer(),
                            Text(category.count.toString(),
                                style: TextStyle(
                                    color: category.isSelected
                                        ? AppColors.PRIMARY_COLOR
                                        : Colors.black,
                                    fontSize: 16))
                          ],
                        ),
                      ),
                    ),
                    ...category.subcategories?.map((subcategory) => InkWell(
                              onTap: () {
                                provider.searchParameters.categoryId =
                                    subcategory.id;
                                provider.search(clearPreviousResults: true);
                              },
                              child: Padding(
                                padding: provider.parentCategories.isNotEmpty
                                    ? EdgeInsetsDirectional.only(
                                        start: 36, end: 10, top: 20)
                                    : EdgeInsetsDirectional.only(
                                        start: 18, end: 10, top: 20),
                                child: Row(
                                  children: [
                                    Text('${subcategory.name}',
                                        style: TextStyle(
                                            color: subcategory.isSelected
                                                ? AppColors.PRIMARY_COLOR
                                                : Colors.black,
                                            fontSize: 16)),
                                    Spacer(),
                                    Text(subcategory.count.toString(),
                                        style: TextStyle(
                                            color: subcategory.isSelected
                                                ? AppColors.PRIMARY_COLOR
                                                : Colors.black,
                                            fontSize: 16))
                                  ],
                                ),
                              ),
                            )) ??
                        []
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget brandCheckboxes(BuildContext context, FilterModule filterModule) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(filterModule.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        initiallyExpanded: true,
        iconColor: Colors.grey,
        tilePadding: EdgeInsets.only(top: 8),
        textColor: Colors.black,
        children: [
          ...filterModule.filterModuleItems.map(
            (e) => InkWell(
              onTap: () {
                provider.toggleBrand(e.id);
                provider.search(clearPreviousResults: true);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Row(
                  children: [
                    Icon(
                      e.isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: e.isSelected
                          ? AppColors.PRIMARY_COLOR
                          : Colors.grey[300],
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(e.name, style: TextStyle(fontSize: 16)),
                    Spacer(),
                    Text(e.count.toString()),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget singleAttributeCheckboxes(
      BuildContext context, FilterModule filterModule) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(filterModule.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        initiallyExpanded: true,
        iconColor: Colors.grey,
        tilePadding: EdgeInsets.only(top: 8),
        textColor: Colors.black,
        children: [
          ...filterModule.filterModuleItems.map(
            (e) => InkWell(
              onTap: () {
                provider.togglePropertyValue(filterModule.id, e.id);
                provider.search(clearPreviousResults: true);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Row(
                  children: [
                    Icon(
                      e.isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: e.isSelected
                          ? AppColors.PRIMARY_COLOR
                          : Colors.grey[300],
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(e.name, style: TextStyle(fontSize: 16)),
                    Spacer(),
                    Text(e.count.toString()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget genderRadioButtons(FilterModule filterModule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(filterModule.name),
        SizedBox(height: 12),
        Wrap(
          children: [
            ...filterModule.filterModuleItems
                .map((e) => InkWell(
                      onTap: () {
                        provider.searchParameters.genderId = e.id;
                        provider.search(clearPreviousResults: true);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              e.isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: e.isSelected
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.grey[300],
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(e.name, style: TextStyle(fontSize: 16)),
                            Spacer(),
                            Text(e.count.toString()),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ],
    );
  }

  Widget colorOptions(FilterModule filterModule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(filterModule.name),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Wrap(
            children: [
              ...filterModule.filterModuleItems
                  .map((e) => GestureDetector(
                        onTap: () {
                          provider.toggleColor(e.id);
                          provider.search(clearPreviousResults: true);
                        },
                        child: Container(
                          margin: EdgeInsetsDirectional.only(end: 8, top: 12),
                          padding: EdgeInsets.all(3),
                          decoration: AppShapes.roundedRectDecoration(
                            radius: 4,
                            borderWidth: 2,
                            borderColor: e.isSelected
                                ? AppColors.PRIMARY_COLOR
                                : Colors.white,
                          ),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: AppShapes.roundedRectDecoration(
                              radius: 4,
                              borderColor: Colors.grey[300],
                              color: Color(
                                  int.parse(e.hexCode.replaceAll('#', '0xff'))),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget priceRangeSlider(BuildContext ctx, PriceFilterModule filterModule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(filterModule.name),
        SizedBox(height: 12),
        RangeSlider(
          values: provider.searchParameters.price ??
              provider.searchResponse.priceModule.rangeValues,
          min: provider.searchResponse.priceModule.rangeValues.start,
          max: provider.searchResponse.priceModule.rangeValues.end,
          divisions: provider.searchResponse.priceModule.rangeValues.end -
                      provider.searchResponse.priceModule.rangeValues.start >
                  250
              ? ((provider.searchResponse.priceModule.rangeValues.end -
                          provider
                              .searchResponse.priceModule.rangeValues.start) /
                      250)
                  .round()
              : 1,
          onChanged: (RangeValues values) {
            provider.searchParameters.price = values;
            provider.notify();
          },
          activeColor: AppColors.PRIMARY_COLOR,
          inactiveColor: Colors.grey[300],
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            '${provider.searchParameters.price?.start?.currencyFormat() ?? provider.searchResponse?.priceModule?.rangeValues?.start?.currencyFormat()} - ${provider.searchParameters.price?.end?.currencyFormat() ?? provider.searchResponse?.priceModule?.rangeValues?.end?.currencyFormat()}',
          ),
        ),
        Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: OutlinedButton(
            onPressed: () => provider.search(clearPreviousResults: true),
            style: ButtonStyle(
              side: MaterialStateProperty.resolveWith(
                  (states) => BorderSide(color: AppColors.PRIMARY_COLOR)),
            ),
            child: Text(FlutterI18n.translate(ctx, 'filter'),
                style: TextStyle(color: AppColors.PRIMARY_COLOR)),
            //onPressed: () => provider.search(),
          ),
        ),
      ],
    );
  }

  Widget showProductsButton(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        height: 45,
        child: TextButton(
          onPressed: () => Get.back(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => AppColors.PRIMARY_COLOR),
          ),
          child: Text(FlutterI18n.translate(context, 'showproducts'),
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      );
}
