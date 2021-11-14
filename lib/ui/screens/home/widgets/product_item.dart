import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/services/global_services/favorite_controller.dart';
import 'package:shopizy/ui/enum/list_item_location.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/widgets/rating_bar.dart';
import 'package:shopizy/utils/double_extensions.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final double itemWidth;
  final ListItemLocation location;
  final bool showFavorite;
  final Function onFavoriteChanged;

  ProductItem(
      {this.product,
      this.itemWidth,
      this.location,
      this.showFavorite = false,
      this.onFavoriteChanged}); // Product product, double imageSize, ListItemLocation location

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider(
            create: (_) => ProductDetailsProvider(product.id),
            child: ProductDetailsScreen(),
          ),
        ),
      ),
      child: Card(
        shape: AppShapes.roundedRectShape(radius: 10),
        elevation: 2,
        shadowColor: Colors.grey[50].withOpacity(0.3),
        margin: location == null
            ? EdgeInsets.zero
            : EdgeInsetsDirectional.only(
                start: location == ListItemLocation.first ? 12 : 6,
                top: 3,
                end: location == ListItemLocation.last ? 12 : 0,
                bottom: 3),
        child: Container(
          width: itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                          width: itemWidth,
                          height: itemWidth * 1.49,
                          imageUrl: '${product.picturePath}?width=$itemWidth&height=${itemWidth * 1.49}',
                          fit: BoxFit.cover),
                    ),
                  ),
                  if (showFavorite)
                    PositionedDirectional(
                      end: 6,
                      top: 6,
                      child: IconButton(
                        icon: Icon(Icons.favorite, size: 28, color: AppColors.PRIMARY_COLOR),
                        onPressed: () async {
                          await FavoriteController.instance.toggleFavorite(product: product);
                          //onFavoriteChanged();
                        },
                      ),
                    ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('${product.brandName} ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                appTheme.textStyles.subtitle1.copyWith(color: appTheme.colors.darkGrey, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: appTheme.textStyles.subtitle1.copyWith(color: appTheme.colors.midGrey)),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    RatingBar(product.averageRate, rateCount: product.rateCount),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //RatingBar(product.averageRate, rateCount: product.rateCount),
                        Container(
                          height: 49,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(product.price.currencyFormat(),
                                  style: appTheme.textStyles.subtitle1.copyWith(
                                      fontWeight: appTheme.textStyles.extraBold,
                                      color: product.discount > 0 ? Colors.grey[400] : Colors.black,
                                      fontSize: product.discount > 0 ? 12 : 16)),
                              Text(product.oldPrice != null && product.oldPrice != 0 ? product.oldPrice.currencyFormat() : '',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Spacer(),
                        product.discount > 0
                            ? Container(
                                height: 42,
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                // decoration: AppShapes.roundedRectDecoration(radius: 16, borderColor: AppColors.PRIMARY_COLOR),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${product.discount}% ${FlutterI18n.translate(context, 'bonus')}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                                    SizedBox(width: 8),
                                    Text(
                                      product.priceAfterDiscount.currencyFormat(),
                                      style: TextStyle(color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.w700, fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(height: 48),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
