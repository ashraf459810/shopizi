import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/screens/search/search_expression_provider.dart';
import 'package:shopizy/ui/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class SearchExpressionScreen extends StatelessWidget {
  SearchExpressionProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: CustomTextField(
          controller: provider.keywordController,
          autoFocus: true,
          hint: FlutterI18n.translate(context, "searchplaceholder"),
          onSubmitted: provider.onKeywordSubmit,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (provider.lastSeenProducts.isNotEmpty) lastSeenProductsList(context),
            if (provider.lastSearchKeywords.isNotEmpty) lastSearchKeywords(context),
          ],
        ),
      ),
    );
  }

  lastSeenProductsList(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FlutterI18n.translate(context, 'lastseenproducts'),
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
          Container(
            height: 130,
            margin: EdgeInsets.only(top: 8, bottom: 28),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.lastSeenProducts.entries.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 16.0, top: 12),
                child: GestureDetector(
                  onTap: () => Get.off(
                    () => ChangeNotifierProvider(
                      create: (_) => ProductDetailsProvider(provider.lastSeenProducts.keys.toList()[index]),
                      child: ProductDetailsScreen(),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: provider.lastSeenProducts.values.toList()[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  lastSearchKeywords(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FlutterI18n.translate(context, 'recentsearch'),
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.lastSearchKeywords.length,
            itemBuilder: (ctx, index) => GestureDetector(
              onTap: () => provider.redirectToSearch(provider.lastSearchKeywords[index]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      provider.lastSearchKeywords[index],
                      style: TextStyle(fontSize: 16),
                    )),
                    IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.grey[400],
                      onPressed: () => provider.removeFromSearchHistory(index),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
