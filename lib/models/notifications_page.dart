import 'package:shopizy/models/notification.dart';

class NotificationsPage {
  final List<Notification> notifications;
  final int lastPage;

  NotificationsPage({this.notifications, this.lastPage});

  factory NotificationsPage.fromJson(Map<String, dynamic> data) {
    return NotificationsPage(
      notifications: (data['data'] as List).map((e) => Notification.fromJson(e)).toList(),
      lastPage: data['lastPage'],
    );
  }
}
