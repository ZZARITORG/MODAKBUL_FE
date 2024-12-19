import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/utils/json_utils.dart';

class FriendReqService {
  Dio dio = DioClient().dio;

  Future<List<FriendReqList>> getFriendReqList() async {
    try {
      // API 요청
      Response response = await dio.get(ApiPath.friendReqList);

      // 응답 데이터 출력
      print('Response status code: ${response.statusCode}'); // 상태 코드 확인
      print('Response data: ${response.data}'); // 전체 응답 데이터 출력
      print('Response data (data key): ${response.data['data']}'); // 'data' 키에 해당하는 값 출력

      // 응답 데이터 파싱
      return JsonUtils().parseFriendReqList(response.data['data'] as List);
    } catch (e) {
      print('Error occurred: $e'); // 에러가 발생한 경우 출력
      return [];
    }
  }
}