import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );
  }

  static Future<void> showBudgetAlert(double spent, double budget) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'budget_alerts', // channel id
          'Budget Alerts', // channel name
          channelDescription: 'Notifications for when you exceed budget limits',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0, // notification id
      'Budget Alert!',
      'You have spent Rs. $spent out of Rs. $budget this month',
      platformDetails,
    );
  }
}
