import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/models/blocked_user.dart';
import 'package:modakbul/models/my_profile.dart';
import 'package:modakbul/models/unblocked_user.dart';

class FriendService {
  Dio dio = DioClient().dio;

  Logger logger = Logger();

  Future<List<BlockedUser>> getBlockedUser() async {
    Response response = await dio.get(ApiPath.friendBlockList);
    logger.d(blockedUserListFromJson(response.data['data'] as List)[0].profileUrl);
    return blockedUserListFromJson(response.data['data'] as List);
  }

  Future<void> unblockedUser(UnblockedUser unblockedUser) async {
    await dio.post(
      ApiPath.friendUnblock,
      data: unblockedUser.toJson(),
    );
  }
}