import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/cart_item.dart';
import 'package:shopizy/providers/user_provider.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/cart/cart_provider.dart';
import 'package:shopizy/ui/screens/checkout/checkout_provider.dart';
import 'package:shopizy/ui/screens/checkout/checkout_screen.dart';
import 'package:shopizy/ui/screens/login/authentication_provider.dart';
import 'package:shopizy/ui/screens/login/authentication_screen.dart';
import 'package:shopizy/ui/screens/product_details/product_details_provider.dart';
import 'package:shopizy/ui/screens/product_details/product_details_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/theme/global_style.dart';
import 'package:shopizy/ui/widgets/custom_text_field.dart';
import 'package:shopizy/utils/double_extensions.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartProvider provider;
  CartController cartController = CartController.instance;

  @override
  void initState() {
    super.initState();
    if (UserController.instance.isAuthenticated &&
        Get.find<CartController>().cartInfo.value.id == null)
      cartController.fetchCart();
  }

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
          FlutterI18n.translate(context, 'cart'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(
        () => cartController.cartInfo.value.id == null
            ? cartController.initialLoading.value
                ? Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.PRIMARY_COLOR),
                      ),
                    ),
                  )
                : emptyState(context)
            : cartController.cartInfo.value.cartItems.isEmpty
                ? emptyState(context)
                : Stack(
                    children: [
                      ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
                            color: Colors.white,
                            child: Column(
                                children: List.generate(
                                    cartController.cartInfo.value.cartItems
                                        .length, (index) {
                              return _buildItem(
                                  context,
                                  cartController
                                      .cartInfo.value.cartItems[index],
                                  index ==
                                      cartController
                                              .cartInfo.value.cartItems.length -
                                          1);
                            })),
                          ),
                          _createCoupon(context),
                          _createSummary(context),
                          SizedBox(height: 80),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _checkoutButton(context),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget emptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
        SizedBox(height: 24),
        Text(FlutterI18n.translate(context, 'noitemsincart')),
      ],
    );
  }

  Widget _buildItem(BuildContext context, CartItem item, bool isLastItem) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 5);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider(
            create: (_) => ProductDetailsProvider(item.productId),
            child: ProductDetailsScreen(),
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(fromWhite: null, name: shoppingCartData[index].name, image: shoppingCartData[index].image, price: shoppingCartData[index].price, rating: 4, review: 23, sale: 36)));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        child: CachedNetworkImage(
                            width: boxImageSize,
                            height: boxImageSize,
                            imageUrl: item.picturePath)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ChangeNotifierProvider(
                                create: (_) =>
                                    ProductDetailsProvider(item.productId),
                                child: ProductDetailsScreen(),
                              ),
                            ),
                          ),
                          child: Text(
                            item.name,
                            style:
                                GlobalStyle.productName.copyWith(fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              if (item.amount != null &&
                                  item.amount != item.totalAmount)
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 6),
                                  child: Text(item.amount.currencyFormat(),
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey[400],
                                          fontSize: 14)),
                                ),
                              Text(item.totalAmount.currencyFormat(),
                                  style: GlobalStyle.productPrice),
                            ],
                          ),
                        ),
                        if (item.discountRate != null && item.discountRate > 0)
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 6),
                                  child: Text('${item.discountRate}%',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: item.couponDiscountApplied
                                              ? Color(0xff28a745)
                                              : Color(0xff007bff))),
                                ),
                                Text(
                                    FlutterI18n.translate(
                                        context,
                                        item.couponDiscountApplied
                                            ? 'coupondiscount'
                                            : 'productdiscount'),
                                    style: GlobalStyle.productPrice.copyWith(
                                        color: item.couponDiscountApplied
                                            ? Color(0xff28a745)
                                            : Color(0xff007bff))),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            item.features,
                            style: GlobalStyle.productName
                                .copyWith(fontSize: 14, color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => provider.deleteItem(item.id),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1, color: Colors.grey[300])),
                                  child: Icon(Icons.delete,
                                      color: AppColors.BLACK_GREY, size: 20),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => provider.updateItemQuantity(
                                        item.id, item.qty - 1),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      height: 28,
                                      decoration: BoxDecoration(
                                          color: AppColors.PRIMARY_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Icon(Icons.remove,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    child: Text(item.qty.toString(),
                                        style: TextStyle()),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => provider.updateItemQuantity(
                                        item.id, item.qty + 1),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      height: 28,
                                      decoration: BoxDecoration(
                                          color: AppColors.PRIMARY_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Icon(Icons.add,
                                          color: Colors.white, size: 20),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (!isLastItem)
            Divider(
              height: 32,
              color: Colors.grey[400],
            )
        ],
      ),
    );
  }

  _createCoupon(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 12),
      child: cartController.cartInfo.value.couponCode?.isEmpty ?? true
          ? Row(
              children: [
                Expanded(
                  child: Container(
                    child: CustomTextField(
                      showBorder: true,
                      controller: provider.couponCodeController,
                      borderColor: Colors.grey[300],
                      hint:
                          FlutterI18n.translate(context, 'entercouponcodehere'),
                      onSubmitted: () => provider.applyCoupon(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  height: 45,
                  child: TextButton(
                    onPressed: () => provider.applyCoupon(),
                    child: Text(FlutterI18n.translate(context, 'applycoupon'),
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => AppColors.PRIMARY_COLOR)),
                  ),
                )
              ],
            )
          : Container(
              decoration: AppShapes.roundedRectDecoration(
                  borderColor: AppColors.PRIMARY_COLOR),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.PRIMARY_COLOR),
                  SizedBox(width: 6),
                  Text('${FlutterI18n.translate(context, 'appliedcoupon')}:',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cartController.cartInfo.value.couponCode,
                      style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[400]),
                      onPressed: () => provider.removeCoupon()),
                ],
              ),
            ),
    );
  }

  _createSummary(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(FlutterI18n.translate(context, 'subtotal'),
                        style: TextStyle(fontSize: 16))),
                Text(
                    FlutterI18n.translate(
                        context,
                        cartController.cartInfo.value.finalSubTotalAmount
                            .currencyFormat()),
                    style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                    child: Text(FlutterI18n.translate(context, 'shipping'),
                        style: TextStyle(fontSize: 16))),
                Text(
                    FlutterI18n.translate(
                        context,
                        cartController.cartInfo.value.finalShippingAmount
                            .currencyFormat()),
                    style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Text(FlutterI18n.translate(context, 'total'),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                Text(
                    FlutterI18n.translate(
                        context,
                        cartController.cartInfo.value.finalTotalAmount
                            .currencyFormat()),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
            if (cartController.cartInfo.value.totalDiscountRate > 0)
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: AppShapes.roundedRectDecoration(
                    radius: 0, borderColor: AppColors.PRIMARY_COLOR),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '${provider.cartInfo.totalDiscountRate}% ${FlutterI18n.translate(context, 'carttotaldiscount')}'),
                    SizedBox(width: 8),
                    Text(
                      provider.cartInfo.totalAmount.currencyFormat(),
                      style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );

  _checkoutButton(BuildContext ctx) {
    return Container(
      height: 55,
      margin: EdgeInsets.all(16),
      child: TextButton(
        onPressed: () async {
          var result =
              await cartController.setCheckoutOptionswithNoParameters();
          print(result.addresses.length);
          if (Provider.of<UserProvider>(ctx, listen: false)
                  .authenticationState ==
              AuthenticationState.real)
            Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (ctx) => ChangeNotifierProvider(
                  create: (ctx) => CheckoutProvider(),
                  child: CheckoutScreen(cartInfo: result),
                ),
              ),
            );
          else
            Navigator.of(ctx).push(MaterialPageRoute(
              builder: (ctx) => ChangeNotifierProvider(
                create: (ctx) =>
                    AuthenticationProvider(onSuccessfulLogin: () {}),
                child: AuthenticationScreen(),
              ),
            ));
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith(
                (states) => AppShapes.roundedRectShape(radius: 6)),
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => AppColors.PRIMARY_COLOR),
            elevation: MaterialStateProperty.resolveWith((states) => 6)),
        child: Text(FlutterI18n.translate(ctx, 'checkout'),
            style: TextStyle(fontSize: 17, color: Colors.white)),
      ),
    );
  }
}
