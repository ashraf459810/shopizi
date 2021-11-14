import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/services/global_services/address_service.dart';

class AddressesProvider with ChangeNotifier {
  bool loading = true;
  List<Address> addresses;

  AddressesProvider() {
    fetchAddress();
  }

  fetchAddress() {
    Get.find<AddressService>().fetchAddresses().then((value) {
      addresses = value;
      loading = false;
      notifyListeners();
    });
  }
}
