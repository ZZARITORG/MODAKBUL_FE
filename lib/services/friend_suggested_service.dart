import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/friend_suggested.dart';
import 'package:modakbul/utils/json_utils.dart';

class FriendSuggestedService {
  Dio dio = DioClient().dio;

  Future<List<FriendSuggested>> getFriendSuggested() async {
    Response response = await dio.get(ApiPath.friendSuggested);
    return JsonUtils().parseFriendSuggested(response.data['data'] as List); // 에러가 발생한 경우 출력
  }
}