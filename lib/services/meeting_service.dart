import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/accepted_modakbul.dart';
import 'package:modakbul/models/my_host_modakbul.dart';

import '../utils/json_utils.dart';

class MeetingService {
  Dio dio = DioClient().dio;

  Future<List<MyHostModakbul>> getMyHostModakbulList() async {
    Response response = await dio.get(ApiPath.meetingHost);
    return JsonUtils().parseMyHostModakbulList(response.data['data'] as List);
  }

  Future<List<AcceptedModakbul>> getAcceptedModakbulList() async {
    Response response = await dio.get(ApiPath.meetingAccept);
    return JsonUtils().parseAcceptedModakbulList(response.data['data'] as List);
  }
}