import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/login.dart';
import 'package:modakbul/models/logout.dart';
import 'package:modakbul/models/phone_number.dart';
import 'package:modakbul/models/refresh_token_request.dart';
import 'package:modakbul/models/refresh_token_response.dart';
import 'package:modakbul/models/tokens.dart';
import 'package:modakbul/models/user.dart';

import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/models/edit_my_profile.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/services/user_service.dart';
import '../main.dart';
import 'firebase_auth_service.dart';

class AuthService {
  Dio dio = DioClient().dio;
  final UserService _userService = UserService();

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

  Future<Tokens> login(Login login) async {
    Response response = await dio.post(
      ApiPath.login,
      data: login.toJson(),
      options: Options(
        extra: {'skipToken': true},
      ),
    );
    final tokens = Tokens.fromJson(response.data['data']);

    final profile = await _userService.getMyProfile();

    const storage = FlutterSecureStorage();
    await Future.wait([
      storage.write(key: AppConstants.phoneNumber, value: profile.phoneNumber),
      prefs.setString(AppConstants.phoneNumber, profile.phoneNumber!)
    ]);

    return tokens;
  }

  Future<void> logout(Logout logout) async {
    await dio.post(
      ApiPath.logout,
      data: logout.toJson(),
    );
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

  Future<void> changePhoneNumber(String newPhoneNumber, String verificationId, String smsCode) async {
    try {

      await FirebaseAuthService().updatePhoneNumber(verificationId, smsCode);

      await _userService.updateMyProfile(
          EditMyProfile(
              phoneNo: newPhoneNumber
          )
      );

      const storage = FlutterSecureStorage();
      await Future.wait([
        storage.write(key: AppConstants.phoneNumber, value: newPhoneNumber),
        prefs.setString(AppConstants.phoneNumber, newPhoneNumber)
      ]);
    } catch (e) {
      throw Exception('Phone number change failed: ${e.toString()}');
    }
  }
}

