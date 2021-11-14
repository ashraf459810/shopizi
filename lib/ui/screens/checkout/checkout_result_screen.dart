import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/payment_result.dart';
import 'package:shopizy/ui/screens/home/home_screen.dart';
import 'package:shopizy/ui/screens/main/main_screen.dart';
import 'package:shopizy/ui/screens/order_details/order_details_provider.dart';
import 'package:shopizy/ui/screens/order_details/order_details_screen.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

class CheckoutResultScreen extends StatelessWidget {
  final PaymentResult paymentResult;

  CheckoutResultScreen(this.paymentResult);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check, size: 90, color: Colors.green),
              SizedBox(height: 16),
              Text(
                  FlutterI18n.translate(
                      context,
                      paymentResult.orderId != null
                          ? 'orderplacemessage'
                          : 'Checkout Failed :('),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20)),
              if (paymentResult.orderId != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text('Order #${paymentResult.orderId}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Colors.grey)),
                ),
              SizedBox(height: 40),
              Container(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Get.find<MainScreenController>().currentIndex = 0;

                    Get.until((route) => route.settings.name == '/main');
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.PRIMARY_COLOR)),
                  child: Text(
                    FlutterI18n.translate(context, 'backtohome'),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Get.find<MainScreenController>().currentIndex = 0;
                    Get.offUntil(
                      MaterialPageRoute(
                        builder: (ctx) => ChangeNotifierProvider(
                          create: (ctx) =>
                              OrderDetailsProvider(paymentResult.orderId),
                          child: OrderDetailsScreen(),
                        ),
                      ),
                      (route) => route.settings.name == '/main',
                    );
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith((states) =>
                          AppShapes.roundedRectShape(
                              borderColor: AppColors.PRIMARY_COLOR))),
                  child: Text(
                    FlutterI18n.translate(context, 'showorderdetails'),
                    style:
                        TextStyle(fontSize: 18, color: AppColors.PRIMARY_COLOR),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
