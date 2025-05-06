import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/services/firebase_auth_service.dart';
import 'package:modakbul/models/edit_my_profile.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/utils/string_utils.dart';
import 'package:modakbul/models/logout.dart';
import 'package:modakbul/services/auth_service.dart';
import 'custom_toast.dart';
import 'log_out_dialog.dart';

class EditPhoneBottomSheet extends StatelessWidget {
  final String verificationId;
  final String smsCode;
  final String newPhoneNumber;
  final VoidCallback onConfirm;
  final PhoneAuthCredential credential;

  const EditPhoneBottomSheet({
    super.key,
    required this.verificationId,
    required this.smsCode,
    required this.newPhoneNumber,
    required this.onConfirm,
    required this.credential
  });

  Future<void> _updatePhoneNumber(BuildContext context) async {
    try {
      // 1. 전화번호 업데이트 (Firebase)
      await FirebaseAuthService().updatePhoneNumber(credential);

      // 2. 서버에 전화번호 업데이트
      await UserService().updateMyProfile(EditMyProfile(phoneNo: StringUtils().removeHyphens(newPhoneNumber)!));

      if (!context.mounted) return;

      // 3. 로그아웃 로직 추가
      try {
        // FCM 토큰 가져오기
        String? fcmToken;
        if (Platform.isIOS) {
          fcmToken = await FirebaseMessaging.instance.getToken();
          print('APNS Token: $fcmToken');
        } else if (Platform.isAndroid) {
          fcmToken = await FirebaseMessaging.instance.getToken();
        }

        if (fcmToken == null || fcmToken.isEmpty) {
          return; // fcmToken이 없으면 로그아웃 중단
        }

        // 로그아웃 API 호출
        AuthService authService = AuthService();
        await authService.logout(Logout(fcmToken: fcmToken));

        // Firebase 로그아웃
        await FirebaseAuth.instance.signOut();

        // Flutter Secure Storage 데이터 삭제
        const storage = FlutterSecureStorage();
        await storage.deleteAll();

        // 네비게이션 처리
        Navigator.of(context).pop(); // 바텀시트 닫기
        Navigator.of(context).pop(); // 인증화면 닫기
        Navigator.of(context).pop(); // 이전 화면 닫기

        // 로그아웃 다이얼로그 표시
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (context) {
                return LogOutDialog();
              }
          );
        }

      } catch (e) {
        print('로그아웃 중 오류 발생: $e');
        // 기존의 네비게이션은 그대로 유지
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      CustomToast.showToast(context, '현재 휴대폰 번호와 동일합니다!', false, customBottom: 86.h);
      print('전화번호 업데이트 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorSchemes.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(StyleConstants.radiusLarge)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: StyleConstants.defaultPadding,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 38.h),
              Text('정말 번호를 변경하시겠습니까?',
                  style: Theme.of(context)
                      .textTheme
                      .bigHeadLine3
                      .copyWith(color: ColorSchemes.orange200)),
              SizedBox(height: 12.h),
              Text('번호를 변경하면 기존 번호로 로그인이 불가능하며\n변경 시 로그아웃 됩니다.',
                  style: Theme.of(context).textTheme.body2.copyWith(
                      color: ColorSchemes.gray300, height: 26.h / 16.sp)),
              SizedBox(height: 29.h),
              SizedBox(
                height: 56.h,
                width: double.infinity,
                child: CustomButton(
                    text: '변경 완료',
                    onPressed: () => _updatePhoneNumber(context),
                    buttonColor: ColorSchemes.orange200,
                    textStyle: Theme.of(context).textTheme.smallHeadLine2,
                    textColor: ColorSchemes.white),
              ),
              SizedBox(height: 16.h)
            ],
          ),
        ),
      ),
    );
  }
}
