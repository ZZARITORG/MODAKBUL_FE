import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/notifications.dart';
import 'package:modakbul/utils/json_utils.dart';

class NotificationService {
  static const String _lastCheckedTimeKey = 'last_checked_notification_time';
  static const String _hasNotificationKey = 'has_notification';

  Dio dio = DioClient().dio;
  final _notificationController = StreamController<bool>.broadcast();
  bool _hasUnreadNotifications = false;

  Stream<bool> get notificationStream => _notificationController.stream;

  Future<void> loadInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    _hasUnreadNotifications = prefs.getBool(_hasNotificationKey) ?? false;
    _notificationController.add(_hasUnreadNotifications);
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasNotificationKey, _hasUnreadNotifications);
  }

  Future<void> _saveLastCheckedTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCheckedTimeKey, DateTime.now().toIso8601String());
  }

  Future<DateTime?> _getLastCheckedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(_lastCheckedTimeKey);
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }

  Future<List<Notifications>> getNotifications() async {
    Response response = await dio.get(ApiPath.notification);
    return JsonUtils().parseNotificationList(response.data['data']);
  }

  Future<void> _checkNewNotifications() async {
    try {
      final lastCheckedTime = await _getLastCheckedTime();
      if (lastCheckedTime == null) {
        await _saveLastCheckedTime();
        return;
      }

      Response response = await dio.get(ApiPath.notification);
      List<Notifications> notifications = JsonUtils().parseNotificationList(response.data['data']);

      bool hasNewNotifications = notifications.any((notification) =>
          notification.createdAt.isAfter(lastCheckedTime)
      );

      if (hasNewNotifications) {
        _hasUnreadNotifications = true;
        _notificationController.add(true);
        await _saveState();
      }
    } catch (e) {
      Logger().e('알림 확인 에러: $e');
    }
  }

  void subscribeToNotifications() async {
    await _checkNewNotifications();

    try {
      final response = await dio.get(
        ApiPath.seeNotification,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: Duration(hours: 1),
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        ),
      );

      final stream = response.data.stream;
      Logger().i('구독 시작: $stream');

      stream.transform(
        StreamTransformer<Uint8List, String>.fromHandlers(
          handleData: (data, sink) {
            try {
              String stringData = String.fromCharCodes(data);
              Logger().i('받은 데이터: $stringData');

              if (stringData.contains('data:')) {
                String jsonStr = stringData.split('data:')[1].trim();
                if (jsonStr.isNotEmpty && jsonStr != 'null') {
                  _hasUnreadNotifications = true;
                  _notificationController.add(_hasUnreadNotifications);
                  _saveState();
                }
              }
              sink.add(stringData);
            } catch (e) {
              Logger().e('데이터 파싱 에러: $e');
            }
          },
          handleError: (error, stackTrace, sink) {
            Logger().e('SSE 에러: $error');
            _notificationController.addError(error, stackTrace);
          },
        ),
      ).listen(
            (data) => Logger().i('파싱된 데이터: $data'),
        onError: (error) => Logger().e('스트림 에러: $error'),
      );

    } on DioException catch (e) {
      Logger().e('SSE 연결 에러: $e');
      _notificationController.addError(e);
    }
  }

  void clearNotification() {
    _hasUnreadNotifications = false;
    _notificationController.add(false);
    _saveState();
    _saveLastCheckedTime();
  }

  void dispose() {
    _notificationController.close();
  }
}