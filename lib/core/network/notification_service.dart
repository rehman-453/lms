import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lms/firebase_options.dart';
import 'package:lms/core/network/api_endpoints.dart';
import 'package:lms/core/network/api_services.dart';

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

  static final ApiServices _apiServices = ApiServices();

  static StreamSubscription<String>? _tokenRefreshSubscription;

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
        AndroidInitializationSettings('app_icon');

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
    try {
      final String? token = await _messaging.getToken();

      debugPrint('================================');
      debugPrint('FCM TOKEN: $token');
      debugPrint('================================');
    } catch (e) {
      debugPrint('FCM TOKEN ERROR: $e');
    }

    // Listen for token refresh
    await _tokenRefreshSubscription?.cancel();

    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((
      newToken,
    ) async {
      debugPrint('FCM TOKEN REFRESHED: $newToken');

      try {
        final response = await _apiServices.postMethod(
          ApiEndpoints.saveFcmTokenUrl,
          {'fcm_token': newToken},
          true,
        );

        debugPrint('REFRESHED FCM TOKEN SYNCED: $response');
      } catch (e) {
        debugPrint('REFRESHED FCM TOKEN SYNC ERROR: $e');
      }
    });

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground notification received');

      final RemoteNotification? notification = message.notification;

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
              icon: 'app_icon',
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
    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('App opened from notification: ${initialMessage.data}');
    }
  }
}
