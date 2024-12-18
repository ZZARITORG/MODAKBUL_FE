import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/modakbul_by_group_id.dart';
import 'package:modakbul/models/modakbul_by_user_id.dart';

class MeetingService {
  Dio dio = DioClient().dio;

  Future<void> createModakbulByUserId(ModakbulByUserId modakbul) async {
    await dio.post(ApiPath.meetingFriend, data: modakbul.toJson());
  }

  Future<void> createModakbulByGroupId(ModakbulByGroupId modakbul) async {
    await dio.post(ApiPath.meetingGroup, data: modakbul.toJson());
  }
}