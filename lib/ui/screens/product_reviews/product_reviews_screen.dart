import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/ui/screens/product_reviews/product_reviews_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/widgets/rating_bar.dart';

// ignore: must_be_immutable
class ProductReviewsScreen extends StatelessWidget {
  ProductReviewsProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'reviews'),
          style: TextStyle(color: Colors.black),
        ),
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
          : SingleChildScrollView(
              controller: provider.scrollController,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    reviewsSummary(context),
                    Container(
                      height: 12,
                      color: Colors.grey[100],
                      margin: EdgeInsets.only(top: 24),
                    ),
                    reviewsList(),
                  ],
                ),
              ),
            ),
    );
  }

  reviewsSummary(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.rates.averageRate, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Icon(Icons.star),
                ],
              ),
              SizedBox(height: 4),
              Text(provider.rates.totalRateCount.toString()),
            ],
          ),
        ),
        Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: BorderDirectional(start: BorderSide(color: Colors.grey[300], width: 2))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ratingInfo(context, 5, provider.rates.rateList['5'], provider.rates.totalRateCount),
                      ratingInfo(context, 4, provider.rates.rateList['4'], provider.rates.totalRateCount),
                      ratingInfo(context, 3, provider.rates.rateList['3'], provider.rates.totalRateCount),
                      ratingInfo(context, 2, provider.rates.rateList['2'], provider.rates.totalRateCount),
                      ratingInfo(context, 1, provider.rates.rateList['1'], provider.rates.totalRateCount),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }

  ratingInfo(BuildContext ctx, int starsCount, int ratesCount, int totalRatesCount) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(minWidth: 12),
            alignment: Alignment.center,
            child: Text(
              starsCount.toString(),
            ),
          ),
          Icon(Icons.star_rate_rounded),
          LinearPercentIndicator(
            width: MediaQuery.of(ctx).size.width / 2.8,
            lineHeight: 8.0,
            percent: ratesCount / totalRatesCount,
            backgroundColor: Colors.grey[300],
            progressColor: AppColors.PRIMARY_COLOR,
          ),
          SizedBox(width: 4),
          Text(ratesCount.toString()),
        ],
      );

  Widget reviewsList() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...provider.reviews
              .map((review) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(review.customer, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            RatingBar(review.rate),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(review.review),
                        SizedBox(height: 4),
                        Text(review.createdOn, style: TextStyle(fontSize: 13, color: AppColors.SOFT_GREY)),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
