import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/ui/screens/reviews/review_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class ReviewScreen extends StatelessWidget {
  ReviewProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'rateandreview'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(imageUrl: provider.review.productImage, width: 80),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(provider.review.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appTheme.textStyles.h2.copyWith(color: AppColors.PRIMARY_COLOR)),
                      const SizedBox(height: 10),
                      if (provider.review.orderId != null)
                        Text('${FlutterI18n.translate(context, 'order')} # ${provider.review.orderId}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: appTheme.textStyles.subtitle1.copyWith(color: appTheme.colors.darkGrey)),
                      if (provider.review.orderId != null) const SizedBox(height: 8),
                      Text(provider.review.createdOn ?? provider.review.createdOn,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appTheme.textStyles.subtitle1.copyWith(color: Colors.grey[500])),
                      SizedBox(height: 36),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              alignment: Alignment.center,
              child: RatingBar(
                initialRating: (provider.review.rate ?? 0).toDouble(),
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star, color: AppColors.PRIMARY_COLOR),
                  half: Icon(Icons.star_border, color: AppColors.PRIMARY_COLOR),
                  empty: Icon(Icons.star_border, color: AppColors.PRIMARY_COLOR),
                ),
                glow: false,
                unratedColor: Colors.grey[300],
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  provider.review.rate = rating.round();
                },
              ),
            ),
            SizedBox(height: 24),
            Text(
              FlutterI18n.translate(context, 'yourreview'),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 8),
            CustomTextField(
              controller: provider.reviewController,
              hint: 'type your review ...',
              padding: EdgeInsets.all(16),
              textStyle: TextStyle(fontSize: 16),
              lines: 8,
            ),
            Container(
              height: 45,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: provider.posting
                  ? Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () => provider.addReview(),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) => AppShapes.roundedRectShape(radius: 8)),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.PRIMARY_COLOR)),
                      child: Text(FlutterI18n.translate(context, 'postreview'), style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
