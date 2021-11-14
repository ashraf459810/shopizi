import 'package:get/get.dart';
import 'package:shopizy/models/notifications_page.dart';
import 'package:shopizy/services/api_services/remote_notification_service.dart';

class NotificationService {
  Future<NotificationsPage> fetchNotificationsPage(int page) async {
    try {
      return Get.find<RemoteNotificationService>().fetchNotificationsPage(page: page);
    } catch (ex) {
      throw ex;
    }
  }

  Future<int> fetchNotificationsCount() async {
    try {
      return Get.find<RemoteNotificationService>().fetchNotificationsCount();
    } catch (ex) {
      throw ex;
    }
  }

  Future setViewed() async {
    try {
      return Get.find<RemoteNotificationService>().setViewed();
    } catch (ex) {
      throw ex;
    }
  }
}
