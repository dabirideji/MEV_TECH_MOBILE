// in notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:template/bootstrap.dart';

@lazySingleton
class NotificationService {
  // NotificationService(this.flutterLocalNotificationsPlugin);
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Show a basic notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', // Must be the same as the ID in the app
      'Your Channel Name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
