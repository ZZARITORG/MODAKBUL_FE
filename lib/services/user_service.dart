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

  Future<List<UserList>> getUserList(String searchQuery) async {
    Response response = await dio.get(ApiPath.user, queryParameters: {
      'search': searchQuery,
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
    await dio.delete(
      ApiPath.userCheck(firebaseUid)
    );
  }

}
