import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shopizy/models/notification.dart';
import 'package:shopizy/models/notifications_page.dart';
import 'package:shopizy/services/global_services/notification_service.dart';

class NotificationsProvider with ChangeNotifier {
  bool loading = true;
  List<Notification> notifications = [];
  int page = 1, lastPage = 1;

  NotificationsProvider() {
    Get.find<NotificationService>().fetchNotificationsPage(page).then((NotificationsPage value) {
      notifications = value.notifications;
      loading = false;
      notifyListeners();
    });
  }
}
