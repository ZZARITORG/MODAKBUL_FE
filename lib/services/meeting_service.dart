import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/my_host_modakbul.dart';

class MeetingService {
  Dio dio = DioClient().dio;

  Future<MyHostModakbul> getMyHostModakbul() async {
    Response response = await dio.get(ApiPath.meetingHost);
    return MyHostModakbul.fromJson(response.data['data']);
  }
}