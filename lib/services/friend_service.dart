import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/models/blocked_user.dart';
import 'package:modakbul/models/contacts.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/models/friend_suggested.dart';
import 'package:modakbul/models/unblocked_user.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/utils/json_utils.dart';

class FriendService {
  Dio dio = DioClient().dio;

  Logger logger = Logger();

  Future<List<BlockedUser>> getBlockedUser() async {
    Response response = await dio.get(ApiPath.friendBlockList);
    return blockedUserListFromJson(response.data['data'] as List);
  }

  Future<void> unblockedUser(UnblockedUser unblockedUser) async {
    await dio.post(
        ApiPath.friendUnblock,
        data: unblockedUser.toJson());
  }

  Future<List<FriendList>> getFriendList() async {
    Response response = await dio.get(
      ApiPath.friendList,
    );
    return JsonUtils().parseFriendList(response.data['data'] as List);
  }

  Future<List<FriendReqList>> getFriendReqList() async {
    Response response = await dio.get(ApiPath.friendReqList);
    return JsonUtils().parseFriendReqList(response.data['data'] as List);
  }

  Future<List<FriendSuggested>> getFriendSuggested(Contacts contacts) async {
    Response response = await dio.post(ApiPath.friendSuggested,
      data: contacts.toJson()
    );
    return JsonUtils().parseFriendSuggested(response.data['data'] as List);
  }

  Future<void> rejectFriend(Uuid uuid) async {
    await dio.post(
        ApiPath.friendReject,
        data: uuid.toJson()
    );
  }

  Future<void> acceptFriend(Uuid uuid) async {
    await dio.post(
        ApiPath.friendAccept,
        data: uuid.toJson()
    );
  }

  Future<void> deleteFriend(Uuid uuid) async {
    try {
      print('deleteFriend 호출 - targetId: ${uuid.targetId}');
      Response response = await dio.delete(
          ApiPath.friend,
          data: uuid.toJson()
      );
      print('deleteFriend 응답 - statusCode: ${response.statusCode}');
      print('deleteFriend 응답 데이터: ${response.data}');
    } catch (e) {
      print('deleteFriend 에러 발생: $e');
      throw e;
    }
  }

  Future<void> requestFriend(Uuid uuid) async {
    Response response =
    await dio.post(
        ApiPath.friendReq,
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
