import 'package:intl/intl.dart';

class Notification {
  final Map<String, dynamic> data;
  final String updatedAt;
  final String title;
  final String body;
  final int type;

  Notification({this.data, this.updatedAt, this.title, this.body, this.type});

  factory Notification.fromJson(Map<String, dynamic> jsonData) {
    return Notification(
      data: jsonData['data'],
      updatedAt: DateFormat('MMM dd, yyyy hh:mm a').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(jsonData['sent_at'], true)),
      title: jsonData['title'],
      body: jsonData['body'],
      type: jsonData['type'],
    );
  }
}
