import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/attribute_option.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/cart/cart_provider.dart';
import 'package:shopizy/ui/screens/cart/cart_screen.dart';
import 'package:shopizy/ui/screens/home/widgets/product_item.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_reviews/product_reviews_provider.dart';
import 'package:shopizy/ui/screens/product_reviews/product_reviews_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/theme/global_style.dart';
import 'package:shopizy/ui/widgets/rating_bar.dart';
import 'package:shopizy/utils/cache_image_network.dart';
import 'package:shopizy/utils/double_extensions.dart';
import 'package:shopizy/utils/list_extensions.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageSlider = 0;
  ProductDetailsProvider provider;
  ScrollController scrollController = ScrollController();
  Color appBarBackgroundColor = Colors.transparent;
  AttributeOption chosenoption;
  int chosedattribueid;
  Product product = Product();
  double price = 0;
  double oldPrice = 0;
  double priceAfterDiscount = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        appBarBackgroundColor =
            scrollController.offset > 30 ? Colors.white : Colors.transparent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);

    // this.price = provider.product.price;
    // this.oldPrice = provider.product.oldPrice;
    // this.priceAfterDiscount = provider.product.priceAfterDiscount;

    return Scaffold(
      body: provider.loading
          ? Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                ),
              ),
            )
          : Stack(
              fit: StackFit.loose,
              children: [
                Column(
                  children: [
                    Flexible(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          _createProductSlider(),
                          _createProductPriceTitleEtc(),
                          if (provider.product.attributes.isNotEmpty)
                            _createProductVariant(),
                          if (provider.groupProducts.isNotEmpty)
                            _createGroupProducts(),
                          if (provider.product.description != null)
                            _createProductDescription(),
                          if (provider.product.specifications.isNotEmpty)
                            _createProductSpecifications(),
                          if (provider.relatedProducts.isNotEmpty)
                            _createRelatedProducts(),
                          if (provider.reviews.isNotEmpty)
                            _createProductReviews(),
                          SizedBox(height: 16)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 2.0,
                          ),
                        ],
                      ),

                      // add to cart button
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: provider.editCart
                            ? [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        AppColors.PRIMARY_COLOR),
                                  ),
                                )
                              ]
                            : provider.product.isAvailable
                                ? [
                                    Container(
                                      height: 50,
                                      child: CustomNumberPicker(
                                        initialValue: 1,
                                        maxValue: 1000000,
                                        minValue: 1,
                                        step: 1,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.grey[300])),
                                        onValue: (value) =>
                                            provider.requestedQuantity = value,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        child: TextButton(
                                          onPressed: provider.canAddToCart
                                              ? () =>
                                                  provider.addToCart(context)
                                              : null,
                                          child: Text(
                                              FlutterI18n.translate(
                                                  context, 'addtocart'),
                                              style: TextStyle(
                                                  color: provider.canAddToCart
                                                      ? Colors.white
                                                      : Colors.grey[500],
                                                  fontWeight: FontWeight.bold)),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        provider.canAddToCart
                                                            ? AppColors
                                                                .PRIMARY_COLOR
                                                            : Colors.grey[300]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      child: Text(
                                          FlutterI18n.translate(
                                              context, 'outofstock'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                    )
                                  ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: appBarBackgroundColor,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.grey),
                    actions: [
                      GestureDetector(
                        onTap: () => Get.to(
                          () => ChangeNotifierProvider(
                            create: (ctx) => CartProvider(),
                            child: CartScreen(),
                          ),
                        ),
                        child: Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: (CartController.instance.cartInfo.value
                                              ?.totalQty ??
                                          0) >
                                      0
                                  ? Stack(
                                      children: [
                                        Icon(Icons.shopping_cart_outlined,
                                            color: appTheme.colors.midGrey,
                                            size: 30),
                                        PositionedDirectional(
                                          end: 0,
                                          top: 0,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            decoration:
                                                AppShapes.circleDecoration(
                                                    color: AppColors
                                                        .PRIMARY_COLOR),
                                            child: Text(
                                              CartController.instance.cartInfo
                                                  .value.totalQty
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Icon(Icons.shopping_cart_outlined,
                                      color: appTheme.colors.midGrey, size: 30),
                            )),
                      ),
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.grey),
                        onPressed: () {
                          Share.share(provider.product.url);
                        },
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _createProductSlider() {
    return Stack(
      children: [
        CarouselSlider(
          items: provider.product.pictures
              .map((item) => GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (_, __, ___) => GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            color: Colors.transparent,
                            child: InteractiveViewer(
                              panEnabled: true,
                              boundaryMargin: EdgeInsets.all(16),
                              child: CachedNetworkImage(
                                imageUrl: provider
                                    .product.pictures[_currentImageSlider],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: buildCacheNetworkImage(url: item),
                    ),
                  ))
              .toList(),
          carouselController: provider.carouselController,
          options: CarouselOptions(
              aspectRatio: 1,
              viewportFraction: 1,
              autoPlay: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageSlider = index;
                });
              }),
        ),
        PositionedDirectional(
          bottom: 12,
          start: 12,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: AppShapes.roundedRectDecoration(
                    radius: 3, color: AppColors.PRIMARY_COLOR),
                child: Text(
                  '${_currentImageSlider + 1} / ${provider.product.pictures.length}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

//here the price
  Widget _createProductPriceTitleEtc() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          changeprice(chosenoption, "price"),
                          style: GlobalStyle.detailProductPrice
                              .copyWith(color: appTheme.colors.orange),
                        ),
                        SizedBox(width: 8),
                        if (provider.product.oldPrice != null &&
                            provider.product.oldPrice != 0)
                          Text(
                              !provider.product.haspriceperoption
                                  ? provider.product.oldPrice.currencyFormat()
                                  : changeprice(chosenoption, "oldprice"),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                  decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    if (provider.product.discount > 0)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        decoration: AppShapes.roundedRectDecoration(
                            radius: 16, borderColor: AppColors.PRIMARY_COLOR),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                '${provider.product.discount}% ${FlutterI18n.translate(context, 'bonus')}'),
                            SizedBox(width: 8),
                            Text(
                              changeprice(chosenoption, "priceafterdiscount"),
                              style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                    provider.isFavorite ?? false
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: AppColors.PRIMARY_COLOR),
                onPressed: () {
                  if (UserController.instance.isAuthenticated)
                    provider.toggleFavorite(context);
                  else
                    UserController.instance.redirectToLogin(
                        onSuccessfulLogin: () => provider
                            .toggleFavorite(context, addToFavorite: true));
                },
              ),
            ],
          ),
          SizedBox(height: 12),
          Text('${provider.product.brand.name} ${provider.product.name}',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
          SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {},
                  child: Row(
                    children: [
                      RatingBar(provider.product.averageRate),
                      SizedBox(
                        width: 3,
                      ),
                      Text('(${provider.product.rateCount})',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.BLACK_GREY)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createProductDescription() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FlutterI18n.translate(context, 'description'),
              style: TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 14)),
          SizedBox(height: 4),
          Html(
            data: provider.product.description,
          ),
        ],
      ),
    );
  }

  Widget _createProductVariant() {
    return Container(
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...provider.product.attributes
                .map(
                  (attribute) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${attribute.name.toUpperCase()}',
                          style: TextStyle(
                              color: AppColors.PRIMARY_COLOR, fontSize: 14)),
                      SizedBox(height: 4),
                      Wrap(
                          children: attribute.options
                              .map((option) =>
                                  attributeOption(attribute.id, option))
                              .toList())
                    ],
                  ),
                )
                .toList(),
          ],
        ));
  }

  Widget _createProductSpecifications() {
    return Container(
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(FlutterI18n.translate(context, 'specification'),
                style: TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 14)),
            ...provider.product.specifications
                .map(
                  (attribute) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('  ${attribute.name.toUpperCase()}',
                            style: TextStyle(
                                color: AppColors.BLACK_GREY, fontSize: 14)),
                        SizedBox(height: 4),
                        ...attribute.options
                            .map((option) => Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(' -  ${option.name}',
                                      style: TextStyle(color: Colors.black)),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ));
  }

  Widget _createGroupProducts() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FlutterI18n.translate(context, 'color'),
              style: TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 14)),
          SizedBox(height: 10),
          Container(
            height: 140,
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: provider.groupProducts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  _currentImageSlider = 0;
                  provider.carouselController.jumpToPage(0);
                  provider.fetchProductWithFavoriteStatus(
                      provider.groupProducts[index].id);
                },
                child: Container(
                  decoration: AppShapes.roundedRectDecoration(
                    radius: 0,
                    borderWidth: 1,
                    borderColor:
                        provider.groupProducts[index].id == provider.product.id
                            ? appTheme.colors.orange
                            : Colors.transparent,
                  ),
                  margin: EdgeInsetsDirectional.only(end: 8),
                  child: CachedNetworkImage(
                    width: 80,
                    height: 140,
                    fit: BoxFit.cover,
                    imageUrl: provider.groupProducts[index].picturePath,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//////// here the sizes
  Widget attributeOption(int attributeId, AttributeOption option) {
    bool isOptionSelected = provider.isOptionSelected(option.id);
    return GestureDetector(
      onTap: () {
        chosenoption = option;

        chosedattribueid = attributeId;
        setState(() {});

        if (option.status)
          setState(() {
            provider.selectedOptions.addAll({attributeId: option.id});
            print(provider.product.haspriceperoption);
            provider.product.haspriceperoption
                ? provider.selectedOptions.addAll({chosedattribueid: option.id})
                : null;
          });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.only(right: 8, top: 8),
        color: isOptionSelected ? appTheme.colors.orange : Colors.grey[200],
        child: Text(option.name,
            style: TextStyle(
                color: !option.status
                    ? Colors.grey[400]
                    : isOptionSelected
                        ? Colors.white
                        : AppColors.CHARCOAL)),
      ),
    );
  }

  Widget _createRelatedProducts() {
    final double itemWidth = (MediaQuery.of(context).size.width / 2);
    return Container(
        margin: EdgeInsets.only(top: 12),
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(FlutterI18n.translate(context, 'relatedproducts'),
                  style:
                      TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 14)),
            ),
            SizedBox(height: 4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...provider.relatedProducts
                      .asMap()
                      .map(
                        (index, e) => MapEntry(
                            index,
                            ProductItem(
                              product: e,
                              itemWidth: itemWidth,
                              location: provider.relatedProducts
                                  .getItemLocation(index),
                            )),
                      )
                      .values
                      .toList()
                ],
              ),
            )
          ],
        ));
  }

  Widget _createProductReviews() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(FlutterI18n.translate(context, 'reviews'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              InkWell(
                  onTap: () => Get.to(() => ChangeNotifierProvider(
                        create: (ctx) =>
                            ProductReviewsProvider(provider.productId),
                        child: ProductReviewsScreen(),
                      )),
                  child: Text(FlutterI18n.translate(context, 'viewall'),
                      style: TextStyle(
                          color: AppColors.PRIMARY_COLOR, fontSize: 14))),
            ],
          ),
          SizedBox(height: 8),
          ...provider.reviews
              .map((review) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(review.customer,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            RatingBar(review.rate),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(review.review),
                        SizedBox(height: 4),
                        Text(review.createdOn,
                            style: TextStyle(
                                fontSize: 13, color: AppColors.SOFT_GREY)),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  String changeprice(AttributeOption option, String value) {
    if (value == "price") {
      if (provider.product.haspriceperoption && option != null) {
        return chosenoption.propertyPrice.price.currencyFormat();
      } else {
        return provider.product.price.currencyFormat();
      }
    }
    if (value == "oldprice") {
      if (option != null) {
        return
            //  chosenoption != null
            //     ?
            chosenoption.propertyPrice.oldPrice >= 0
                ? chosenoption.propertyPrice.oldPrice.currencyFormat()
                // : " "
                : "";
      } else {
        return provider.product.oldPrice.currencyFormat();
      }
    }
    //  else {
    //   return
    //   provider.product.oldPrice.currencyFormat();
    // }
    if (value == "priceafterdiscount") {
      if (option != null)
        return chosenoption != null
            ? chosenoption.propertyPrice.priceAfterDiscount > 0
                ? chosenoption.propertyPrice.priceAfterDiscount.currencyFormat()
                : provider.product.priceAfterDiscount.currencyFormat()
            : "";
      else
        return provider.product.priceAfterDiscount.currencyFormat();
    }
  }
}
