import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/ui/screens/addresses/address_provider.dart';
import 'package:shopizy/ui/screens/addresses/addresses_provider.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

import 'address_screen.dart';

// ignore: must_be_immutable
class AddressesScreen extends StatelessWidget {
  AddressesProvider provider;

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
          FlutterI18n.translate(context, 'addresses'),
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_location_alt_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (ctx) => ChangeNotifierProvider.value(
                    value: AddressProvider(),
                    child: AddressScreen(),
                  ),
                ),
              )
                  .then(
                (anyChange) {
                  if (anyChange ?? false) provider.fetchAddress();
                },
              );
            },
          )
        ],
      ),
      body: provider.loading
          ? Container()
          : provider.addresses.isEmpty
              ? emptyState()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(children: [...provider.addresses.map((e) => addressCell(context, e)).toList()]),
                ),
    );
  }

  addressCell(BuildContext ctx, Address address) {
    return InkWell(
      onTap: () => Navigator.of(ctx)
          .push(
        MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider.value(
            value: AddressProvider(addressToEdit: address),
            child: AddressScreen(),
          ),
        ),
      )
          .then(
        (anyChange) {
          if (anyChange ?? false) provider.fetchAddress();
        },
      ),
      child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration:
            AppShapes.roundedRectDecoration(borderWidth: 1, borderColor: address.isSelected ? AppColors.PRIMARY_COLOR : Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              address.city,
              style: TextStyle(fontSize: 15, color: Colors.grey[400]),
            ),
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
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.PRIMARY_COLOR, size: 20),
                    SizedBox(width: 6),
                    Text(address.name, style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Text(FlutterI18n.translate(ctx, 'phonenumber'), style: TextStyle(color: AppColors.PRIMARY_COLOR)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_android, color: AppColors.PRIMARY_COLOR, size: 20),
                SizedBox(width: 6),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(address.phoneNumber, style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  emptyState() {}
}
