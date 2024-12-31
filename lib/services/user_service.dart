import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/edit_my_profile.dart';
import 'package:modakbul/models/my_profile.dart';

class UserService {
  Dio dio = DioClient().dio;

  Future<MyProfile> getMyProfile() async {
    Response response = await dio.get(ApiPath.userMe);
    return MyProfile.fromJson(response.data['data']);
  }

  Future<void> updateMyProfile(EditMyProfile editMyProfile) async {
    await dio.patch(
      ApiPath.user,
      data: editMyProfile.toJson()
    );
  }

  Future<void> deleteUser() async {
    await dio.delete(
        ApiPath.user
    );
  }

}
