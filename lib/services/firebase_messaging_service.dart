import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modakbul/screens/alert/alert_screen.dart';
import 'package:modakbul/firebase_options.dart';
import 'package:modakbul/utils/global_variable.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;

  /// 1) 로컬 노티 설정
  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) return;

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // iOS 권한
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false, badge: true, sound: true,
    );
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  /// 2) 토큰 가져오기
  Future<void> getToken() async {
    String? token;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      token = await FirebaseMessaging.instance.getToken();
    }
    if (token != null) debugPrint('FCM Token: $token');
  }

  /// 3) 백그라운드 핸들러
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseMessagingService().setupFlutterNotifications();
    FirebaseMessagingService()._showLocalNotificationFromBackground(msg);
  }

  /// 4) 초기화 (클릭 이벤트)
  void initialize() {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) _handleMessage(msg);
    });
  }

  /// 5) local notification helper
  void _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) {
    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
    );
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    flutterLocalNotificationsPlugin.show(
      0, title, body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  /// 6) foreground 에서 메시지 수신 → local notification 띄우기
  void registerForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      final title = msg.notification?.title ?? '모닥불 알림';
      final body = msg.notification?.body ??
          msg.data['message'] ??
          '새 알림이 도착했어요';
      _showLocalNotification(
        title: title,
        body: body,
        payload: msg.data['customData']?.toString(),
      );
    });
  }

  /// 7) background 핸들러에서 local notification (data-only 일 때)
  void _showLocalNotificationFromBackground(RemoteMessage msg) {
    final title = msg.notification?.title ?? '모닥불 알림';
    final body = msg.notification?.body ??
        msg.data['message'] ??
        '새 알림이 도착했어요';
    _showLocalNotification(
      title: title,
      body: body,
      payload: msg.data['customData']?.toString(),
    );
  }

  /// 8) 알림 클릭 시 화면 이동
  void _handleMessage(RemoteMessage msg) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(GlobalVariable.navState.currentContext!).push(
        MaterialPageRoute(builder: (_) => const AlertScreen()),
      );
    });
  }
}