import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/modakbul_by_group_id.dart';
import 'package:modakbul/models/modakbul_by_user_id.dart';
import 'package:modakbul/models/accepted_modakbul.dart';
import 'package:modakbul/models/my_host_modakbul.dart';
import 'package:modakbul/models/pending_modakbul.dart';

import 'package:modakbul/models/accept_modakbul.dart';
import 'package:modakbul/models/accept_modakbul_response.dart';
import 'package:modakbul/models/modakbul_detail.dart';
import 'package:modakbul/utils/json_utils.dart';

class MeetingService {
  Dio dio = DioClient().dio;

  Future<void> createModakbulByUserId(ModakbulByUserId modakbul) async {
    await dio.post(ApiPath.meetingFriend, data: modakbul.toJson());
  }

  Future<void> createModakbulByGroupId(ModakbulByGroupId modakbul) async {
    await dio.post(ApiPath.meetingGroup, data: modakbul.toJson());
  }

  Future<List<MyHostModakbul>> getMyHostModakbulList() async {
    Response response = await dio.get(ApiPath.meetingHost);
    return JsonUtils().parseMyHostModakbulList(response.data['data'] as List);
  }

  Future<List<AcceptedModakbul>> getAcceptedModakbulList() async {
    Response response = await dio.get(ApiPath.meetingAccept);
    return JsonUtils().parseAcceptedModakbulList(response.data['data'] as List);
  }

  Future<List<PendingModakbul>> getPendingModakbulList() async {
    Response response = await dio.get(ApiPath.meetingPending);
    return JsonUtils().parsePendingModakbulList(response.data['data'] as List);
  }

  Future<ModakbulDetail> getModakbulDetail(String id) async {
    Response response = await dio.get('${ApiPath.meeting}/$id');
    return ModakbulDetail.fromJson(response.data['data']);
  }

  Future<AcceptModakbulResponse> acceptModakbul(AcceptModakbul request) async {
    Response response = await dio.post(
      ApiPath.meetingAccept,
      data: request.toJson(),
    );
    return AcceptModakbulResponse.fromJson(response.data['data']);
  }

  Future<void> cancelModakbul(String id) async {
    await dio.post('${ApiPath.meetingCancel}/$id');
  }

  Future<void> deleteModakbul(String id) async {
    await dio.delete('${ApiPath.meeting}/$id');
  }
}

