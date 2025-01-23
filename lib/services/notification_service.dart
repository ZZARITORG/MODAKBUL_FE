import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/notifications.dart';
import 'package:modakbul/utils/json_utils.dart';

class NotificationService {
  Dio dio = DioClient().dio;
  final _notificationController = StreamController<bool>.broadcast();

  Stream<bool> get notificationStream => _notificationController.stream;

  Future<List<Notifications>> getNotifications() async {
    Response response = await dio.get(ApiPath.notification);
    return JsonUtils().parseNotificationList(response.data['data']);
  }

  void subscribeToNotifications() async {
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
      Logger().i('구독두곧구독: $stream');

      stream.transform(
        StreamTransformer<Uint8List, String>.fromHandlers(
          handleData: (data, sink) {
            _notificationController.add(true);
          },
          handleError: (error, stackTrace, sink) {
            Logger().e('SSE에러: $error');
            _notificationController.addError(error, stackTrace);
          },
        ),
      ).listen(
            (data) => Logger().i('데이터데이터데이터데이터: $data'),
        onError: (error) => Logger().e('stream에러에러에러: $error'),
      );

    } on DioException catch (e) {
      Logger().e('SSE 연결 에러: $e');
      _notificationController.addError(e);
    }
  }

  void clearNotification() {
    _notificationController.add(false);
  }

  void dispose() {
    _notificationController.close();
  }
}
