import 'dart:convert';
import 'dart:io' show Platform;

import 'package:crypto/crypto.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/settings/storage_keys.dart';

import 'api_config.dart';

class RemoteUserService {
  Future<bool> loginAnonymous() async {
    String url = '$baseUrl/customers/login-anonymous';
    try {
      Response response = await post(
        Uri.parse(url),
        body: json.encode({'Device': Platform.isAndroid ? 'Android' : 'IOS'}),
        headers: {
          'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
          "Content-Type": "application/json",
        },
      );
      return response.statusCode == 200;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> checkIsExist(String phoneNumber) async {
    String key = md5.convert(utf8.encode('$phoneNumber' + '_hSjYs1dU6eS_!=2D')).toString();
    String url = '$baseUrl/customers/isexist';
    try {
      Response response = await post(
        Uri.parse(url),
        body: json.encode({
          'key': key,
          'mobilePhone': phoneNumber,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
      return response.statusCode == 200 && (json.decode(response.body) as Map)['exist'];
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> login(String name, String anonymousUserId) async {
    int genderId = GetStorage().read(StorageKeys.genderId) ?? 0;
    String url = '$baseUrl/customers/login';
    try {
      Map<String, dynamic> bodyMap = name != null // Registration case
          ? {
              'name': name,
              'device': Platform.isAndroid ? 'Android' : 'IOS',
              'anonymousFirebaseUserId': anonymousUserId,
              'gender': genderId,
              'fcmToken': Get.find<UserController>().fcmToken,
            }
          : {
              'device': Platform.isAndroid ? 'Android' : 'IOS',
              'anonymousFirebaseUserId': anonymousUserId,
              'gender': genderId,
              'fcmToken': Get.find<UserController>().fcmToken,
            };
      Response response = await post(
        Uri.parse(url),
        body: json.encode(bodyMap),
        headers: generalHeaders
          ..addAll({
            'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
            "Content-Type": "application/json",
          }),
      );
      return response.statusCode == 200;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> updateFCMToken(String fcmToken) async {
    String url = '$baseUrl/customers/fcm-token';
    try {
      Response response = await put(
        Uri.parse(url),
        body: json.encode({'token': fcmToken}),
        headers: generalHeaders
          ..addAll({
            'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
            "Content-Type": "application/json",
          }),
      );
      return response.statusCode == 200;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<bool> editProfile(String name, int gender) async {
    int genderId = GetStorage().read(StorageKeys.genderId) ?? 0;
    String url = '$baseUrl/customers/login';
    try {
      Response response = await post(
        Uri.parse(url),
        body: json.encode({
          'name': name,
          'device': Platform.isAndroid ? 'Android' : 'IOS',
          'gender': genderId,
        }),
        headers: generalHeaders
          ..addAll({
            'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
            "Content-Type": "application/json",
          }),
      );
      return response.statusCode == 200;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
