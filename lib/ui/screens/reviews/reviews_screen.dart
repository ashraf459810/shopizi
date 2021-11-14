import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/ui/screens/reviews/tabs/reviewed/reviewed_products_page.dart';
import 'package:shopizy/ui/screens/reviews/tabs/reviewed/reviewed_products_provider.dart';
import 'package:shopizy/ui/screens/reviews/tabs/waiting/waiting_reviews_page.dart';
import 'package:shopizy/ui/screens/reviews/tabs/waiting/waiting_reviews_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.grey),
          elevation: 0,
          title: Text(
            FlutterI18n.translate(context, 'reviews'),
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: AppColors.PRIMARY_COLOR,
            indicatorColor: AppColors.PRIMARY_COLOR,
            tabs: [
              Tab(
                  child: Text(
                FlutterI18n.translate(context, 'waitingreviews'),
              )),
              Tab(
                  child: Text(
                FlutterI18n.translate(context, 'reviewedproducts'),
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (ctx) => WaitingReviewsProvider(),
              child: WaitingReviewsPage(),
            ),
            ChangeNotifierProvider(
              create: (ctx) => ReviewedProductsProvider(),
              child: ReviewedProductsPage(),
            ),
          ],
        ),
      ),
    );
  }
}
