import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/models/cart_info.dart';
import 'package:shopizy/models/payment_option.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/ui/screens/addresses/addresses_provider.dart';
import 'package:shopizy/ui/screens/addresses/addresses_screen.dart';
import 'package:shopizy/ui/screens/checkout/checkout_provider.dart';
import 'package:shopizy/ui/screens/static/static_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/utils/double_extensions.dart';

// ignore: must_be_immutable
class CheckoutScreen extends StatefulWidget {
  final Function onSuccessfulCheckout;
  CartInfo cartInfo;

  CheckoutScreen({this.onSuccessfulCheckout, this.cartInfo});
  @override
  _CheckoutScreen createState() => _CheckoutScreen();
}

class _CheckoutScreen extends State<CheckoutScreen> {
  CartController cartController = CartController.instance;
  CheckoutProvider provider;
  PaymentOption paymentOptionselected;
  Address address = Address();
  PaymentOption paymentOption;

  @override
  void initState() {
    getSelectedAddress(widget.cartInfo);
    getSelectedCashMethod(widget.cartInfo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);

    // provider.selectedPaymentOption = getSelectedCashMethod(widget.cartInfo) ??
    //     widget.cartInfo.paymentOptions[0];

    // provider.selectAddress(address);
    // provider.selectedPaymentOption = paymentOption;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        centerTitle: true,
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'checkout'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: provider.loading
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              FlutterI18n.translate(context, 'deliveryaddress'),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[500]))),
                      addEditButton(context),
                    ],
                  ),
                  SizedBox(height: 8),
                  selectAddressButton(context),
                  SizedBox(height: 8),
                  _createSummary(context),
                  _paymentOptions(context),
                  _termsAndConditionsCheckbox(context),
                  _placeOrderButton(context),
                ],
              ),
            ),
    );
  }

  addEditButton(BuildContext ctx) => InkWell(
        onTap: () => Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (ctx) => ChangeNotifierProvider(
              create: (ctx) => AddressesProvider(),
              child: AddressesScreen(),
            ),
          ),
        ).then((value) => provider.fetchAddress()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(FlutterI18n.translate(ctx, 'addedit'),
              style: TextStyle(fontSize: 16, color: AppColors.PRIMARY_COLOR)),
        ),
      );

//here the address
  selectAddressButton(BuildContext context) => InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.grey[100],
            builder: (ctx) => Wrap(children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: provider.cartInfo.addresses.length,
                    itemBuilder: (ctx, index) =>
                        addressCell(ctx, provider.cartInfo.addresses[index]),
                  )),
            ]),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: AppShapes.roundedRectDecoration(
              borderColor: Colors.grey[200], radius: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  provider.selectedAddress == null
                      ? getSelectedAddress(widget.cartInfo) == null
                          ? 'please add address'
                          : ' ${getSelectedAddress(widget.cartInfo).split(",").first} - ${getSelectedAddress(widget.cartInfo).split(",").last}'
                      : '${provider.selectedAddress.city} - ${provider.selectedAddress.address}',
                  style: TextStyle(
                      fontSize: 17,
                      color: provider.selectedAddress == null
                          ? Colors.grey[400]
                          : Colors.black),
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.grey[400],
              )
            ],
          ),
        ),
      );

  addressCell(BuildContext ctx, Address address) {
    return InkWell(
      onTap: () async {
        print("here at first");
        if (paymentOptionselected == null) {
          paymentOptionselected = getSelectedCashMethod(widget.cartInfo);
          // ??
          // provider.cartInfo.addresses[0];
        }
        var cartinfoo = await cartController.recallcheckout(
            address.id,
            paymentOptionselected != null
                ? paymentOptionselected.id
                : widget.cartInfo.paymentOptions[0].id);

        provider.selectAddress(address);

        widget.cartInfo = cartinfoo;
        print(address.id);
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: AppShapes.roundedRectDecoration(
            radius: 4,
            borderWidth: 1,
            borderColor: address == provider.selectedAddress
                ? AppColors.PRIMARY_COLOR
                : Colors.white),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (address.title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(address.title,
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[400])),
                    ),
                  Text('${address.city} - ${address.address}',
                      softWrap: true,
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createSummary(BuildContext context) => Container(
        decoration: AppShapes.roundedRectDecoration(
            radius: 8, borderColor: Colors.grey[300]),
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              alignment: AlignmentDirectional.centerStart,
              child: Text(FlutterI18n.translate(context, 'ordersummary'),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            Row(
              children: [
                Expanded(
                    child: Text(FlutterI18n.translate(context, 'subtotal'),
                        style: TextStyle(fontSize: 16))),
                Text(
                    FlutterI18n.translate(context,
                        widget.cartInfo.finalSubTotalAmount.currencyFormat()),
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
                    FlutterI18n.translate(context,
                        widget.cartInfo.finalShippingAmount.currencyFormat()),
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
                    FlutterI18n.translate(context,
                        widget.cartInfo.finalTotalAmount.currencyFormat()),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
            if (provider.cartInfo.totalDiscountRate > 0)
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

  _paymentOptions(BuildContext ctx) {
    return Container(
      decoration: AppShapes.roundedRectDecoration(radius: 8),
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            alignment: AlignmentDirectional.centerStart,
            child: Text(FlutterI18n.translate(ctx, 'paymentoptions'),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: provider.cartInfo.paymentOptions.length,
                itemBuilder: (ctx, index) {
                  PaymentOption option =
                      provider.cartInfo.paymentOptions[index];
                  bool isSelected = option == provider.selectedPaymentOption;
                  // paymentOptionselected = option;

                  return InkWell(
                    onTap: () async {
                      if (option.isActive) {
                        paymentOptionselected = option;
                        provider.selectedPaymentOption =
                            provider.cartInfo.paymentOptions[index];
                      }
                      print("here the pay id ");

                      var cartinfoo;

                      if (provider.cartInfo.paymentOptions[index].isActive) {
                        cartinfoo = await cartController.recallcheckout(
                            provider.selectedAddress.id,
                            provider.cartInfo.paymentOptions[index].id);
                        widget.cartInfo = cartinfoo;
                      }

                      setState(() {});
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getSelectedCashMethod(widget.cartInfo) != null &&
                                    provider.cartInfo.paymentOptions[index]
                                            .title ==
                                        getSelectedCashMethod(widget.cartInfo)
                                            .title
                                ? provider
                                        .cartInfo.paymentOptions[index].isActive
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off
                                : Icons.radio_button_off,
                            color: getSelectedCashMethod(widget.cartInfo) !=
                                        null &&
                                    provider.cartInfo.paymentOptions[index]
                                            .title ==
                                        getSelectedCashMethod(widget.cartInfo)
                                            .title
                                ? AppColors.PRIMARY_COLOR
                                : provider
                                        .cartInfo.paymentOptions[index].isActive
                                    ? Colors.grey[300]
                                    : Colors.grey[300],
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text(option.title, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _termsAndConditionsCheckbox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              provider.selectedPaymentOption = paymentOption;

              provider.acceptTermAndConditions =
                  !provider.acceptTermAndConditions;
            },
            child: Icon(
              provider.acceptTermAndConditions
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: provider.acceptTermAndConditions
                  ? AppColors.PRIMARY_COLOR
                  : Colors.grey[300],
              size: 28,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () => Get.to(() => StaticScreen(
                    title: FlutterI18n.translate(context, 'termsandconditions'),
                    pageName: 'terms-and-conditions',
                  )),
              child: Text(
                  FlutterI18n.translate(
                      context, 'ihavereadandagreetermsandconditionns'),
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  _placeOrderButton(BuildContext ctx) {
    return provider.doingCheckout
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 24, bottom: 24),
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
            margin: EdgeInsets.only(top: 24, bottom: 16),
            child: TextButton(
              onPressed:
                  provider.enablePlaceOrder ? () => provider.checkout() : null,
              style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith(
                    (states) => AppShapes.roundedRectShape(radius: 6)),
                backgroundColor: MaterialStateProperty.resolveWith((states) =>
                    provider.enablePlaceOrder
                        ? AppColors.PRIMARY_COLOR
                        : Colors.grey[400]),
              ),
              child: Text(FlutterI18n.translate(ctx, 'placeorder'),
                  style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          );
  }

  String getSelectedAddress(CartInfo cartInfo) {
    String addresss;

    for (var i = 0; i < cartInfo.addresses.length; i++) {
      if (cartInfo.addresses[i].isSelected == true) {
        addresss =
            cartInfo.addresses[i].city + "," + cartInfo.addresses[i].address;

        address = cartInfo.addresses[i];
      }
    }
    return addresss;
  }

  PaymentOption getSelectedCashMethod(CartInfo cartInfo) {
    PaymentOption cashMethod;

    for (var i = 0; i < cartInfo.paymentOptions.length; i++) {
      if (cartInfo.paymentOptions[i].isSelected == true) {
        cashMethod = cartInfo.paymentOptions[i];
        paymentOption = cartInfo.paymentOptions[i];
      }
    }
    return cashMethod;
  }
}
