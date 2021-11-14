import 'package:flutter/material.dart';
import 'package:shopizy/main.dart';

class NotificationIcon extends StatelessWidget {
  final int count;

  NotificationIcon(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsetsDirectional.only(end: 12),
      child: Stack(
        children: <Widget>[
          Icon(Icons.notifications, color: appTheme.colors.midGrey),
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(color: appTheme.colors.notificationColor, borderRadius: BorderRadius.circular(10)),
              constraints: BoxConstraints(minWidth: 14, minHeight: 14),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
