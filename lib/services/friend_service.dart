import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/utils/json_utils.dart';

class FriendService {
  Dio dio = DioClient().dio;

  Future<List<FriendList>> getFriendList() async {
    Response response = await dio.get(
      ApiPath.friendList,
    );
    return JsonUtils().parseFriendList(response.data['data'] as List);
  }
}
