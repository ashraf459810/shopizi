import 'package:get/get.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/models/shipping_point.dart';
import 'package:shopizy/services/api_services/remote_address_service.dart';

class AddressService {
  Future<List<Address>> fetchAddresses() async {
    try {
      return await Get.find<RemoteAddressService>().fetchAddresses();
    } catch (ex) {
      throw ex;
    }
  }

  Future<List<ShippingPoint>> fetchShippingPoints() async {
    try {
      return await Get.find<RemoteAddressService>().fetchShippingPoints();
    } catch (ex) {
      throw ex;
    }
  }

  Future addUpdateAddress(Address address) async {
    try {
      return await Get.find<RemoteAddressService>().addUpdateAddress(address);
    } catch (ex) {
      throw ex;
    }
  }

  Future deleteAddress(int addressId) async {
    try {
      return await Get.find<RemoteAddressService>().deleteAddress(addressId);
    } catch (ex) {
      throw ex;
    }
  }
}
