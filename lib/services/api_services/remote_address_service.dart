import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:shopizy/models/address.dart';
import 'package:shopizy/models/shipping_point.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

import 'api_config.dart';

class RemoteAddressService {
  Future<List<Address>> fetchAddresses() async {
    String url = '$baseUrl/customers/addresslist';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return (json.decode(response.body) as List).map((e) => Address.fromJson(e)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<List<ShippingPoint>> fetchShippingPoints() async {
    String url = '$baseUrl/shippingpoints';
    try {
      Response response = await get(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return (json.decode(response.body) as List).map((e) => ShippingPoint.fromJson(e)).toList();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future addUpdateAddress(Address address) async {
    String url = address.id == null ? '$baseUrl/customers/persist-address' : '$baseUrl/customers/persist-address/${address.id}';
    try {
      Response response = await post(
        Uri.parse(url),
        body: json.encode(address),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode != 200) throw Exception();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future deleteAddress(int addressId) async {
    String url = '$baseUrl/customers/delete-address/$addressId';
    try {
      Response response = await delete(
        Uri.parse(url),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      if (response.statusCode != 200) throw Exception();
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
