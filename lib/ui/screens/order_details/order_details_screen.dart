import 'package:cached_network_image/cached_network_image.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/models/cart_item.dart';
import 'package:shopizy/ui/screens/order_details/order_details_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/theme/global_style.dart';
import 'package:shopizy/utils/double_extensions.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        centerTitle: true,
        elevation: 0,
        title: Text(
          '${FlutterI18n.translate(context, 'order')} # ${provider.orderId}',
          style: TextStyle(color: Colors.black),
        ),
      ),
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
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  orderInfo(context, provider.orderDetails.createdOn, provider.orderDetails.statusDescription,
                      provider.orderDetails.cancelReason,   provider.orderDetails.paymentOptionTitle),
                  SizedBox(height: 16),
                  deliveryAddress(context, provider.orderDetails.deliveryAddress),
                  SizedBox(height: 16),
                  orderItems(context, provider.orderDetails.orderItems),
                  orderSummary(
                      context,
                      provider.orderDetails.subTotal,
                      provider.orderDetails.totalShippingAmount,
                      provider.orderDetails.totalAmount,
                      provider.orderDetails.cartDiscountRate,
                      provider.orderDetails.totalDiscountAmount),
                  if (provider.orderDetails.status == 1) cancelOrderButton(context),
                ],
              ),
            ),
    );
  }

  orderInfo(BuildContext context, String createdOn, String statsText, String cancelReason , String paymentMethod) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppShapes.roundedRectDecoration(radius: 8),
        child: Column(
          children: [
            Row(
              children: [
                Text('${FlutterI18n.translate(context, 'date')}: ', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                Text(createdOn, style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
                       Row(
              children: [
                Text('${FlutterI18n.translate(context, 'paymentmethod')}: ', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                Text(paymentMethod, style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text('${FlutterI18n.translate(context, 'status')}: ', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                Text(statsText, style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
      
            if (cancelReason != null)
              Container(
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: AppShapes.roundedRectDecoration(color: Colors.red.withOpacity(0.1), radius: 4),
                child: Row(
                  children: [
                    Text('${FlutterI18n.translate(context, 'cancelreason')}: ',
                        style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Text(cancelReason, style: TextStyle(fontSize: 15, color: Colors.red)),
                  ],
                ),
              ),
          ],
        ),
      );

  deliveryAddress(BuildContext ctx, Address address) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppShapes.roundedRectDecoration(radius: 8),
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(FlutterI18n.translate(ctx, 'shippingaddress'), style: TextStyle(fontSize: 17, color: AppColors.PRIMARY_COLOR)),
                SizedBox(height: 12),
                Text(address.city, style: TextStyle(fontSize: 15, color: Colors.grey[400])),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColors.PRIMARY_COLOR, size: 20),
                    SizedBox(width: 6),
                    Expanded(child: Text(address.address, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
                  ],
                ),
                if (address.name != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, color: AppColors.PRIMARY_COLOR, size: 20),
                        SizedBox(width: 6),
                        Text(address.name, style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                if (address.phoneNumber != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(FlutterI18n.translate(ctx, 'phonenumber'),
                            style: TextStyle(fontSize: 15, color: AppColors.PRIMARY_COLOR)),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.phone_android, color: AppColors.PRIMARY_COLOR, size: 20),
                            SizedBox(width: 6),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(address.phoneNumber, style: TextStyle(fontSize: 15)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  orderItems(BuildContext ctx, List<CartItem> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppShapes.roundedRectDecoration(radius: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FlutterI18n.translate(ctx, 'items'), style: TextStyle(fontSize: 17, color: AppColors.PRIMARY_COLOR)),
          SizedBox(height: 12),
          ...items
              .map((e) => Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              child: CachedNetworkImage(width: 100, imageUrl: e.picturePath)),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.name,
                                  style: GlobalStyle.productName.copyWith(fontSize: 17, color: AppColors.BLACK_GREY),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                if (e.totalAmount != e.amount)
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(end: 8.0, bottom: 4),
                                    child: Text(e.amount.currencyFormat(),
                                        style:
                                            TextStyle(fontSize: 15, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                                  ),
                                Text(e.totalAmount.currencyFormat(),
                                    style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                                if (e.options.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Column(
                                      children: [
                                        ...e.options
                                            .map((option) => Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Row(
                                                    children: [
                                                      Text('${option.attributeName}: ',
                                                          style: TextStyle(fontSize: 15, color: Colors.grey)),
                                                      Text(option.name, style: TextStyle(fontSize: 15, color: Colors.black)),
                                                    ],
                                                  ),
                                                ))
                                            .toList()
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('${FlutterI18n.translate(ctx, 'quantity')}: ',
                                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                                    Text(e.qty.toString(), style: TextStyle(fontSize: 15, color: Colors.black)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text('${FlutterI18n.translate(ctx, 'status')}: ',
                                        style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold)),
                                    Text(e.status, style: TextStyle(fontSize: 15, color: AppColors.PRIMARY_COLOR)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          provider.cancellingItemId == e.id
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(bottom: 24),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                                    ),
                                  ),
                                )
                              : provider.orderDetails.status == 1
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.grey[500],
                                      ),
                                      onPressed: () async {
                                        if (await confirm(
                                          ctx,
                                          content: Text(FlutterI18n.translate(ctx, 'orderitemcancelmessage')),
                                          textOK: Text(FlutterI18n.translate(ctx, 'yes')),
                                          textCancel: Text(FlutterI18n.translate(ctx, 'no')),
                                        )) {
                                          provider.cancelOrderItem(ctx, e.id);
                                        }
                                      })
                                  : Container()
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  orderSummary(BuildContext context, double subtotal, double shipping, double total, int discountRate, double discount) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (discountRate > 0)
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Text(
                      FlutterI18n.translate(context, 'carttotaldiscount'),
                      style: TextStyle(fontSize: 16, color: AppColors.PRIMARY_COLOR),
                    ),
                    Spacer(),
                    Text(
                      '-${discount.currencyFormat()} (${discountRate}%)',
                      style: TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 16),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(child: Text(FlutterI18n.translate(context, 'subtotal'), style: TextStyle(fontSize: 16))),
                Text(FlutterI18n.translate(context, subtotal.currencyFormat()), style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text(FlutterI18n.translate(context, 'shipping'), style: TextStyle(fontSize: 16))),
                Text(FlutterI18n.translate(context, shipping.currencyFormat()), style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Text(FlutterI18n.translate(context, 'total'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                Text(FlutterI18n.translate(context, total.currencyFormat()),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      );

  cancelOrderButton(BuildContext ctx) {
    return provider.cancelling
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 24),
            child: Container(
              alignment: Alignment.center,
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
              ),
            ),
          )
        : Container(
            height: 55,
            margin: EdgeInsets.only(bottom: 24),
            child: TextButton(
              onPressed: () async {
                if (await confirm(
                  ctx,
                  content: Text(FlutterI18n.translate(ctx, 'cancelmessage')),
                  textOK: Text(FlutterI18n.translate(ctx, 'yes')),
                  textCancel: Text(FlutterI18n.translate(ctx, 'no')),
                )) {
                  provider.cancelOrder(ctx);
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith((states) => AppShapes.roundedRectShape(radius: 6)),
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
              ),
              child: Text(FlutterI18n.translate(ctx, 'cancelorder'), style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          );
  }
}
