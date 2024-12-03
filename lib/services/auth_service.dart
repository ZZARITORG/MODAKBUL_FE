import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/phone_number.dart';
import 'package:modakbul/models/refresh_token_request.dart';
import 'package:modakbul/models/refresh_token_response.dart';
import 'package:modakbul/models/tokens.dart';
import 'package:modakbul/models/user.dart';

class AuthService {
  Dio dio = DioClient().dio;

  Future<bool> checkIdDuplication(String userId) async {
    Response response = await dio.get(
      ApiPath.checkIdDuplication(userId),
      options: Options(
        extra: {'skipToken': true},
      ),
    );
    return response.data['data'];
  }

  Future<Tokens> signUp(User user) async {
    Response response = await dio.post(
      ApiPath.signUp,
      data: user.toJson(),
      options: Options(
        extra: {'skipToken': true},
      ),
    );
    return Tokens.fromJson(response.data['data']);
  }

  Future<Tokens> login(PhoneNumber phoneNumber) async {
    Response response = await dio.post(
      ApiPath.login,
      data: phoneNumber.toJson(),
      options: Options(
        extra: {'skipToken': true},
      ),
    );
    return Tokens.fromJson(response.data['data']);
  }

  Future<bool> checkUserExists(PhoneNumber phoneNumber) async {
    Response response = await dio.post(
      ApiPath.checkUserExists,
      data: phoneNumber.toJson(),
      options: Options(
        extra: {'skipToken': true},
      ),
    );
    return response.data['data'];
  }

  Future<RefreshTokenResponse> refreshAccessToken(
      RefreshTokenRequest refreshToken) async {
    Response response = await dio.post(ApiPath.tokenRefresh,
        data: refreshToken.toJson(),
        options: Options(extra: {'skipToken': true}));
    return RefreshTokenResponse.fromJson(response.data['data']);
  }
}
