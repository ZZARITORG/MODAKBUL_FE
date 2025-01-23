import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/group_list.dart';
import 'package:modakbul/utils/json_utils.dart';

class GroupService {
  Dio dio = DioClient().dio;

  Future<List<Group>> getGroupList() async {
    Response response = await dio.get(
      ApiPath.group,
    );
    return JsonUtils().parseGroupList(response.data['data'] as List);
  }

  Future<Response> createGroup(String groupName, List<String> friendIds) async {
    try {
      Response response = await dio.post(
        ApiPath.group, // 그룹 생성 API 경로
        data: jsonEncode({
          'groupName': groupName, // 그룹 이름
          'friendIds': friendIds, // 친구 ID 배열
        }),
      );
      return response;
    } catch (e) {
      print('Error creating group: $e');
      rethrow; // 오류를 호출자에게 다시 던짐
    }
  }

  Future<Response> updateGroup(String groupId, String groupName, List<String> friendIds) async {
    try {
      final String url = '${ApiPath.group}/$groupId';
      Response response = await dio.put(
        url,
        data: jsonEncode({
          'groupName': groupName, // 그룹 이름
          'friendIds': friendIds, // 친구 ID 배열
        }), // 요청 본문
      );

      return response; // 응답 반환
    } catch (e) {
      print('Error updating group: $e');
      rethrow; // 에러가 발생하면 다시 던짐
    }
  }
}