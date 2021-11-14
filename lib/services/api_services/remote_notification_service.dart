import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:shopizy/models/notifications_page.dart';
import 'package:shopizy/services/api_services/api_config.dart';
import 'package:shopizy/services/global_services/user_controller.dart';

class RemoteNotificationService {
  Future<NotificationsPage> fetchNotificationsPage({int page}) async {
    try {
      Response response = await get(
        Uri.parse('$notificationsUrl/search'),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return NotificationsPage.fromJson(json.decode(response.body));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<int> fetchNotificationsCount() async {
    try {
      Response response = await get(
        Uri.parse('$notificationsUrl/count'),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
      return json.decode(response.body)['count'];
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future setViewed() async {
    try {
      Response response = await post(
        Uri.parse('$notificationsUrl/setviewed'),
        headers: generalHeaders
          ..addAll(
            {
              'Authorization': 'Bearer ${Get.find<UserController>().firebaseToken}',
              'Content-Type': 'application/json',
            },
          ),
      );
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
