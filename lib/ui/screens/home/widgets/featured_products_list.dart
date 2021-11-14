import 'package:flutter/material.dart';
import 'package:shopizy/models/product.dart';
import 'package:shopizy/ui/screens/home/widgets/product_item.dart';
import 'package:shopizy/utils/list_extensions.dart';

class FeaturedProductsList extends StatelessWidget {
  final List<Product> products;

  FeaturedProductsList(this.products);

  @override
  Widget build(BuildContext context) {
    final double itemWidth = (MediaQuery.of(context).size.width / 2);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...products
              .asMap()
              .map(
                (index, e) => MapEntry(
                    index,
                    ProductItem(
                      product: e,
                      itemWidth: itemWidth,
                      location: products.getItemLocation(index),
                    )),
              )
              .values
              .toList()
        ],
      ),
    );
  }
}
