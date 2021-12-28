import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/ui/screens/addresses/address_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:shopizy/ui/theme/global_style.dart';
import 'package:shopizy/ui/widgets/custom_text_field.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddressProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, 'address'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: provider.loading
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: [
                  SizedBox(height: 24),
                  Text(FlutterI18n.translate(context, 'title'),
                      style: GlobalStyle.authTitle),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: provider.titleController,
                    hint: FlutterI18n.translate(context, 'typeaddresstitle'),
                    textStyle: TextStyle(fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    //focusNode: focusNode,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.label_outline),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(FlutterI18n.translate(context, 'city'),
                      style: GlobalStyle.authTitle),
                  SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: AppShapes.roundedRectDecoration(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: provider.selectedShippingPoint,
                        hint: Text(
                          FlutterI18n.translate(context, 'selectcity'),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: appTheme.colors.hint),
                        ),
                        items: provider.shippingPoints
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.title)))
                            .toList(),
                        onChanged: (selectedShippingPoint) => provider
                            .selectedShippingPoint = selectedShippingPoint,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(FlutterI18n.translate(context, 'address'),
                      style: GlobalStyle.authTitle),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: provider.addressController,
                    hint: FlutterI18n.translate(context, 'typeyouraddress'),
                    textStyle: TextStyle(fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    //focusNode: focusNode,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  SizedBox(height: 45),
                  Text(FlutterI18n.translate(context, 'fullname'),
                      style: GlobalStyle.authTitle),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: provider.nameController,
                    hint: FlutterI18n.translate(context, 'typeyourname'),
                    textStyle: TextStyle(fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    //focusNode: focusNode,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(FlutterI18n.translate(context, 'phonenumber'),
                      style: GlobalStyle.authTitle),
                  SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomTextField(
                      controller: provider.phoneNumberController,
                      hint: '750XXXXXXX',
                      textStyle: TextStyle(fontSize: 16),
                      textInputFormatters: [
                        LengthLimitingTextInputFormatter(10)
                      ],
                      keyboardType: TextInputType.phone,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: IntrinsicWidth(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.phone_android),
                              SizedBox(width: 6),
                              Text('+964', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        if (provider.addressController.text != null &&
                            provider.titleController.text != null &&
                            provider.nameController.text != null &&
                            provider.selectedShippingPoint != null &&
                            provider.phoneNumberController.text != null) {
                          provider.addUpdateAddress();
                        } else {
                          final snackBar = SnackBar(
                              backgroundColor: Colors.orange,
                              content: Text(
                                FlutterI18n.translate(
                                    context, 'addressvalidationmessage'),
                              ));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) =>
                              AppShapes.roundedRectShape(radius: 6)),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => AppColors.PRIMARY_COLOR)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_location_alt_outlined,
                              color: Colors.white, size: 22),
                          SizedBox(width: 12),
                          Text(FlutterI18n.translate(context, 'saveaddress'),
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  if (provider.address.id != null)
                    Container(
                      height: 55,
                      margin: EdgeInsets.only(top: 10),
                      child: TextButton(
                        onPressed: () => provider.deleteAddress(),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) =>
                              AppShapes.roundedRectShape(
                                  radius: 6, borderColor: Colors.red)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Colors.red, size: 22),
                            SizedBox(width: 12),
                            Text(
                                FlutterI18n.translate(
                                    context, 'Remove address'),
                                style:
                                    TextStyle(fontSize: 17, color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
