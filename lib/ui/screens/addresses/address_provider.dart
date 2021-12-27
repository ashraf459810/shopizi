import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/models/shipping_point.dart';
import 'package:shopizy/services/global_services/address_service.dart';

class AddressProvider with ChangeNotifier {
  bool loading = true;
  List<ShippingPoint> shippingPoints;
  Address address;
  ShippingPoint _selectedShippingPoint;
  ShippingPoint get selectedShippingPoint => _selectedShippingPoint;
  set selectedShippingPoint(ShippingPoint shippingPoint) {
    _selectedShippingPoint = shippingPoint;
    this.address.shippingPointId = shippingPoint.id;
    this.address.city = shippingPoint.title;
    notifyListeners();
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  AddressProvider({Address addressToEdit}) {
    Get.find<AddressService>().fetchShippingPoints().then((value) {
      shippingPoints = value;
      this.address = addressToEdit ?? Address();
      addressController.text = address.address;
      nameController.text = address.name;
      titleController.text = address.title;
      phoneNumberController.text =
          address.phoneNumber?.replaceFirst('+964', '');
      if (addressToEdit != null)
        _selectedShippingPoint = value.firstWhere(
            (element) => element.id == addressToEdit.shippingPointId);
      loading = false;
      notifyListeners();
    });
  }

  addUpdateAddress() async {
    try {
      address.address =
          addressController.text.isNotEmpty ? addressController.text : null;
      address.name =
          nameController.text.isNotEmpty ? nameController.text : null;
      address.title =
          titleController.text.isNotEmpty ? titleController.text : null;
      address.phoneNumber = phoneNumberController.text.isNotEmpty
          ? '+964${phoneNumberController.text}'
          : null;
      await Get.find<AddressService>().addUpdateAddress(address);
      Get.back(result: true);
    } catch (ex) {
      Fluttertoast.showToast(msg: 'please complete your information');
    }
  }

  deleteAddress() async {
    try {
      await Get.find<AddressService>().deleteAddress(address.id);
      Get.back(result: true);
    } catch (ex) {
      Fluttertoast.showToast(msg: 'Failed');
    }
  }
}
