import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/edit_my_profile.dart';
import 'package:modakbul/models/my_profile.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/user_list.dart';
import 'package:modakbul/utils/json_utils.dart';

class UserService {
  Dio dio = DioClient().dio;

  Future<MyProfile> getMyProfile() async {
    Response response = await dio.get(ApiPath.userMe);
    return MyProfile.fromJson(response.data['data']);
  }

  Future<List<UserList>> getUserList(String searchQuery, {required int page}) async {
    Response response = await dio.get(ApiPath.user, queryParameters: {
      'search': searchQuery,
      'page': page
    });
    return JsonUtils().parseUserList(response.data['data'] as List);
  }

  Future<UserCheck> getUserCheck(String id) async {
    Response response = await dio.get(ApiPath.userCheck(id));
    return UserCheck.fromJson(response.data['data']);
  }

  Future<void> updateMyProfile(EditMyProfile editMyProfile) async {
    await dio.patch(
      ApiPath.user,
      data: editMyProfile.toJson()
    );
  }

  Future<void> deleteUser(String firebaseUid) async {
    try {
      final response = await dio.delete(
          ApiPath.userDelete(firebaseUid)
      );
      print('삭제 응답: ${response.data}');
    } catch (e) {
      print('삭제 에러: $e');
      throw e;
    }
  }
}
