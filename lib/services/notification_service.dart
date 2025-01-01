import 'package:dio/dio.dart';

import '../constants/api_path.dart';
import '../core/dio_client.dart';
import '../models/notification.dart';
import '../utils/json_utils.dart';

class NotificationService {
  Dio dio = DioClient().dio;

  Future<List<Notification>> getNotifications() async {
    Response response = await dio.get(ApiPath.notification);
    return JsonUtils().parseNotificationList(response.data['data']);
  }
}