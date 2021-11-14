import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/services/global_services/favorite_controller.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/login/authentication_provider.dart';
import 'package:shopizy/ui/screens/login/authentication_screen.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/widgets/rating_bar.dart';
import 'package:shopizy/utils/double_extensions.dart';

// ignore: must_be_immutable
class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with AutomaticKeepAliveClientMixin {
  FavoriteController favoriteController = FavoriteController.instance;
  UserController userController = UserController.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (UserController.instance.authenticationState.value == AuthenticationState.real)
      favoriteController.fetchFavoritesPage(fromStart: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            FlutterI18n.translate(context, 'favorites'),
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Obx(
          () => userController.authenticationState.value == AuthenticationState.real
              ? favoriteController.favoriteProducts.isEmpty && favoriteController.initialLoading.value
                  ? Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                        ),
                      ),
                    )
                  : favoriteController.favoriteProducts.isEmpty
                      ? emptyState(context)
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Obx(() => ListView.builder(
                                itemCount: favoriteController.favoriteProducts.length,
                                itemBuilder: (ctx, index) {
                                  Product product = favoriteController.favoriteProducts[index];
                                  return GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => ChangeNotifierProvider(
                                          create: (_) => ProductDetailsProvider(product.id),
                                          child: ProductDetailsScreen(),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 8),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                      decoration: AppShapes.roundedRectDecoration(radius: 10),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(imageUrl: product.picturePath, width: 80)),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('${product.brandName} ${product.name}',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: appTheme.textStyles.subtitle1.copyWith(color: appTheme.colors.darkGrey)),
                                                const SizedBox(height: 6),
                                                Text(product.price.currencyFormat(),
                                                    style: appTheme.textStyles.subtitle1
                                                        .copyWith(fontWeight: appTheme.textStyles.extraBold)),
                                                const SizedBox(height: 3),
                                                Text(
                                                    product.oldPrice != null && product.oldPrice != 0
                                                        ? product.oldPrice.currencyFormat()
                                                        : '',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[400],
                                                        decoration: TextDecoration.lineThrough)),
                                                if (product.discount > 0)
                                                  Container(
                                                    height: 42,
                                                    margin: EdgeInsets.symmetric(vertical: 6),
                                                    padding: EdgeInsets.symmetric(vertical: 3),
                                                    // decoration: AppShapes.roundedRectDecoration(radius: 16, borderColor: AppColors.PRIMARY_COLOR),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('${product.discount}% ${FlutterI18n.translate(context, 'bonus')}',
                                                            style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          product.priceAfterDiscount.currencyFormat(),
                                                          style: TextStyle(
                                                              color: AppColors.PRIMARY_COLOR,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                SizedBox(height: 6),
                                                RatingBar(product.averageRate, rateCount: product.rateCount),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.delete, color: Colors.grey),
                                              onPressed: () async {
                                                await FavoriteController.instance.toggleFavorite(product: product);
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )),
                        )
              : unauthenticatedState(context),
        ));
  }

  unauthenticatedState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Icon(Icons.favorite_border, size: 100, color: Colors.grey[300]),
        SizedBox(height: 24),
        Text(FlutterI18n.translate(context, 'logintocontinue')),
        SizedBox(height: 12),
        Container(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ChangeNotifierProvider(
                    create: (ctx) => AuthenticationProvider(onSuccessfulLogin: () {
                      //favoriteController.fetchFavoritesPage(fromStart: true);
                    }),
                    child: AuthenticationScreen(),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(horizontal: 36)),
              backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.PRIMARY_COLOR),
            ),
            child: Text(
              FlutterI18n.translate(context, 'login'),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        )
      ],
    );
  }

  emptyState(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[300]),
          SizedBox(height: 24),
          Text(FlutterI18n.translate(context, 'favoritelistempty')),
        ],
      ),
    );
  }
}
