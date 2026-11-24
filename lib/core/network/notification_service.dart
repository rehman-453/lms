// lib\core\network\notification_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lms/firebase_options.dart';

// import '../../firebase_options.dart';

// Local notification plugin
final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

// Android notification channel
const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel(
      'lms_notifications',
      'LMS Notifications',
      description: 'Notifications for LMS updates and announcements',
      importance: Importance.high,
    );

// Background notification handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Background notification: ${message.messageId}');
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request notification permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await localNotifications.initialize(settings: initializationSettings);

    // Create Android notification channel
    await localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(notificationChannel);

    // Get FCM token
    // ignore: deprecated_member_use

    // Get FCM token
    try {
      // ignore: deprecated_member_use
      String? token = await _messaging.getToken();

      debugPrint('================================');
      debugPrint('FCM TOKEN: $token');
      debugPrint('================================');
    } catch (e) {
      debugPrint('FCM TOKEN ERROR: $e');
    }

    // Listen for token refresh
    // ignore: deprecated_member_use
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM TOKEN REFRESHED: $newToken');
    });

    // String? token = await _messaging.getToken();

    // debugPrint('FCM TOKEN: $token');

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground notification received');

      RemoteNotification? notification = message.notification;

      if (notification != null) {
        localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannel.id,
              notificationChannel.name,
              channelDescription: notificationChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Notification tapped while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped: ${message.data}');
    });

    // Notification tapped when app was terminated
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('App opened from notification: ${initialMessage.data}');
    }
  }
}
