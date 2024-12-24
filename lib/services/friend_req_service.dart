import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/utils/json_utils.dart';

class FriendReqService {
  Dio dio = DioClient().dio;

  Future<List<FriendReqList>> getFriendReqList() async {
    // API 요청
    Response response = await dio.get(ApiPath.friendReqList);
    return JsonUtils().parseFriendReqList(response.data['data'] as List); // 에러가 발생한 경우 출력
  }
}