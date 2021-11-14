import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/order.dart';
import 'package:shopizy/ui/screens/order_details/order_details_provider.dart';
import 'package:shopizy/ui/screens/order_details/order_details_screen.dart';
import 'package:shopizy/ui/screens/orders/orders_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/utils/double_extensions.dart';

// ignore: must_be_immutable
class OrdersScreen extends StatelessWidget {
  OrdersProvider provider;

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
          FlutterI18n.translate(context, 'orderhistory'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: provider.loading
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                controller: provider.scrollController,
                itemCount: provider.orders.length,
                itemBuilder: (ctx, index) => orderCell(context, provider.orders[index], index == provider.orders.length - 1),
              ),
            ),
    );
  }

  orderCell(BuildContext ctx, Order order, bool isLastItem) => InkWell(
        onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (ctx) => ChangeNotifierProvider(
                      create: (ctx) => OrderDetailsProvider(order.id),
                      child: OrderDetailsScreen(),
                    ))).then((reload) {
          if (reload ?? false) provider.fetchOrders();
        }),
        child: Container(
          decoration: AppShapes.roundedRectDecoration(radius: 16),
          margin: EdgeInsets.only(top: 10, bottom: isLastItem ? 10 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child:
                    Text(order.statusName, style: TextStyle(fontSize: 16, color: AppColors.ASSENT_COLOR, fontWeight: FontWeight.bold)),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.createdOn, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                    SizedBox(height: 6),
                    Text('Order # ${order.id}', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        ClipRRect(
                          child: CachedNetworkImage(imageUrl: order.sampleProduct.picturePath, width: 60),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.sampleProduct.title, style: TextStyle(fontSize: 17)),
                              if (order.totalItemCount > 1)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '+${order.totalItemCount - 1} ${FlutterI18n.translate(ctx, 'otherproducts')}',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(FlutterI18n.translate(ctx, 'total')),
                    Text(
                      order.totalAmount.currencyFormat(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
