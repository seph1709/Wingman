import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  static pushNotification(String title, int progress) {
    var androidDetailsDownloading = AndroidNotificationDetails(
      '1',
      'my channel',
      importance: Importance.max,
      priority: Priority.max,
      progress: progress,
      showProgress: true,
      maxProgress: 100,
      ongoing: progress == 100 ? false : true,
      onlyAlertOnce: true
    );

    var notificationDetails = NotificationDetails(
      android: androidDetailsDownloading,
    );
    _notification.show(
      1,
      title,
      "In progress",
      notificationDetails,
    );
  }


  static pushNotificationStatus(String title,String status) {


    var androidDetails = AndroidNotificationDetails(
      '1',
      'my channel',
      importance: Importance.max,
      priority: Priority.max,
    );

    var notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    _notification.show(
      1,
      title,
      status,
      notificationDetails,
    );
  }
}
