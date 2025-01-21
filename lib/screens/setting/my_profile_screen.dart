import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/logout.dart';
import 'package:modakbul/models/my_profile.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/auth_service.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/log_out_dialog.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/setting_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late Future<MyProfile> _futureProfile;

  UserService userService = UserService();
  AuthService authService = AuthService();
  ///late SharedPreferences pref;
  late String userName;
  late String userId;
  late String profileUrl;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    setState(() {
      userName = prefs.getString(AppConstants.userName) ?? '';
      userId = prefs.getString(AppConstants.userId) ?? '';
      profileUrl = prefs.getString(AppConstants.profileUrl) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 33.h),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(StyleConstants.radiusMedium),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(14.w, 23.h, 14.w, 25.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Expanded(
                                    child: Row(
                                      children: [
                                        Stack(children: [
                                          CircleAvatar(
                                            radius:
                                            StyleConstants.circleSizeS,
                                            backgroundImage:
                                            NetworkImage(profileUrl),
                                          ),
                                          Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                ColorSchemes.orange200,
                                                radius: StyleConstants
                                                    .circleSizeXXXXXXXS,
                                                child: SvgPicture.asset(
                                                    IconPath
                                                        .photoCameraOrange100,
                                                    width: 13.83.r),
                                              )),
                                        ]),
                                        SizedBox(width: 8.w),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bigHeadLine4
                                                    .copyWith(
                                                    color: ColorSchemes
                                                        .gray500),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                userId,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body3
                                                    .copyWith(
                                                    color: ColorSchemes
                                                        .gray400),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                          SizedBox(width: 32.w),
                          InkWell(
                            onTap: () async {
                              final result = await Routes.navigateAndReturn(context, Routes.editMyProfileScreen);
                              if (result == true) {
                                await initSharedPreferences();
                              }
                            },
                            child: Text(
                              '수정하기',
                              style: Theme.of(context)
                                  .textTheme
                                  .smallHeadLine3
                                  .copyWith(color: ColorSchemes.orange200),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    '사용자 설정',
                    style: Theme.of(context)
                        .textTheme
                        .smallHeadLine3
                        .copyWith(color: ColorSchemes.orange200),
                  ),
                  SizedBox(height: 14.h),
                  SettingMenu.arrow(
                      menu: '계정정보 관리',
                      icon: IconPath.verifiedUser,
                      iconWidth: 16.r,
                      onPressed: () {
                        Routes.navigateTo(context, Routes.commonSettingScreen);
                      }),
                  SizedBox(height: 18.h),
                  SettingMenu.arrow(
                      menu: '알림설정',
                      icon: IconPath.notificationsBell,
                      iconWidth: 13.r,
                      onPressed: () {
                        Routes.navigateTo(context, Routes.alertSettingScreen);
                      }),
                  SizedBox(height: 18.h),
                  SettingMenu.arrow(
                      menu: '친구설정',
                      icon: IconPath.friend,
                      iconWidth: 18.r,
                      onPressed: () {
                        Routes.navigateTo(context, Routes.friendSettingScreen);
                      }),
                  SizedBox(height: 32.h),
                  Text(
                    '보안',
                    style: Theme.of(context)
                        .textTheme
                        .smallHeadLine3
                        .copyWith(color: ColorSchemes.orange200),
                  ),
                  SizedBox(height: 14.h),
                  SettingMenu.arrow(
                      menu: '이용약관',
                      iconWidth: 12.r,
                      icon: IconPath.lock,
                      onPressed: () {
                        Routes.navigateTo(context, Routes.termsScreen);
                      }),
                  SizedBox(height: 18.h),
                  SettingMenu.arrow(
                      menu: '정보',
                      iconWidth: 15.r,
                      icon: IconPath.description,
                      onPressed: () {
                        Routes.navigateTo(context, Routes.infoScreen);
                      }),
                ],
              ),
            ),
            Center(
              child: InkWell(
                overlayColor: WidgetStateProperty.all(ColorSchemes.orange000),
                onTap: () async {

                  try {
                    // FCM 토큰 가져오기
                    String? fcmToken;
                    if (Platform.isIOS) {
                      // await Future.delayed(Duration(seconds: 2));
                      fcmToken = await FirebaseMessaging.instance.getAPNSToken();
                      print('APNS Token: $fcmToken');
                    } else if (Platform.isAndroid) {
                      fcmToken = await FirebaseMessaging.instance.getToken();
                    }

                    if (fcmToken == null || fcmToken.isEmpty) {
                      return; // fcmToken이 없으면 로그아웃 중단
                    }

                    // 로그아웃 API 호출
                    await authService.logout(Logout(fcmToken: fcmToken));

                    // Firebase 로그아웃
                    await FirebaseAuth.instance.signOut();

                    // Flutter Secure Storage 데이터 삭제
                    const storage = FlutterSecureStorage();
                    await storage.deleteAll();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return LogOutDialog();
                        });
                  } catch (e) {
                    // 에러 발생 시 처리 없이 무시
                  }
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: SvgPicture.asset(IconPath.powerSettingsNew,
                          width: 18.r)),
                  SizedBox(width: 2.w),
                  Text(
                    '로그아웃',
                    style: Theme.of(context)
                        .textTheme
                        .smallHeadLine3
                        .copyWith(color: ColorSchemes.orange100),
                  )
                ]),
              ),
            ),
            SizedBox(height: 38.h)
          ],
        ),
      ),
    );
  }
}
