import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/utils/json_utils.dart';

class FriendService {
  Dio dio = DioClient().dio;

  Future<List<FriendList>> getFriendList() async {
    Response response = await dio.get(
      ApiPath.friendList,
    );
    print(response.data['data']);
    return JsonUtils().parseFriendList(response.data['data'] as List);
  }

  Future<void> deleteFriend(Uuid uuid) async {
    await dio.delete(
        ApiPath.friend,
        data: uuid.toJson()
    );
  }

  Future<void> blockFriend(Uuid uuid) async {
    await dio.post(
        ApiPath.friendBlock,
        data: uuid.toJson()
    );
  }
}