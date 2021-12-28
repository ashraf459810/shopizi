import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/product_review.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/screens/reviews/review_provider.dart';
import 'package:shopizy/ui/screens/reviews/review_screen.dart';
import 'package:shopizy/ui/screens/reviews/tabs/reviewed/reviewed_products_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/widgets/rating_bar.dart';

// ignore: must_be_immutable
class ReviewedProductsPage extends StatelessWidget {
  ReviewedProductsProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return provider.initialLoading
        ? Center(
            child: Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
              ),
            ),
          )
        : ListView.builder(
            controller: provider.scrollController,
            itemCount: provider.reviews.length,
            itemBuilder: (ctx, index) =>
                listItem(context, provider.reviews[index]),
          );
  }

  listItem(BuildContext context, ProductReview review) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider(
            create: (_) => ProductDetailsProvider(review.productId),
            child: ProductDetailsScreen(),
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: AppShapes.roundedRectDecoration(radius: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child:
                  CachedNetworkImage(imageUrl: review.productImage, width: 120),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(review.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textStyles.h2
                          .copyWith(color: AppColors.PRIMARY_COLOR)),
                  const SizedBox(height: 10),
                  RatingBar(review.rate),
                  const SizedBox(height: 10),
                  Text(review.review,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textStyles.subtitle1.copyWith(
                          color: appTheme.colors.darkGrey, fontSize: 16)),
                  const SizedBox(height: 8),
                  if (review.createdOn != null)
                    Text(review.createdOn,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: appTheme.textStyles.subtitle1
                            .copyWith(color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${FlutterI18n.translate(context, 'status')}:',
                          style: TextStyle(fontSize: 15)),
                      SizedBox(width: 4),
                      Expanded(
                          child: Text(review.reviewStatus,
                              style: TextStyle(fontSize: 15))),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Get.to(
                      () => ChangeNotifierProvider(
                        create: (ctx) => ReviewProvider(review),
                        child: ReviewScreen(),
                      ),
                    ).then((value) {
                      if (value ?? false) provider.reload();
                    }),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith((states) =>
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0)),
                        shape: MaterialStateProperty.resolveWith(
                            (states) => AppShapes.roundedRectShape(radius: 5)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => AppColors.PRIMARY_COLOR)),
                    child: Text(FlutterI18n.translate(context, 'details'),
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
