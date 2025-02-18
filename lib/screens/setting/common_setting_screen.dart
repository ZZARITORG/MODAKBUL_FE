import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/setting_menu.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/models/my_profile.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/models/edit_my_profile.dart';
import 'package:modakbul/main.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonSettingScreen extends StatefulWidget {
  const CommonSettingScreen({super.key});

  @override
  State<CommonSettingScreen> createState() => _CommonSettingScreenState();
}

class _CommonSettingScreenState extends State<CommonSettingScreen> with WidgetsBindingObserver {
  bool _isToggled = false;
  UserService userService = UserService();
  String phone = '';

  String formatPhoneNumber(String phone) {
    if (phone.length == 11) {
      return '${phone.substring(0, 3)}-${phone.substring(3, 7)}-${phone.substring(7)}';
    }
    return phone;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadInitialState() async {
    try {
      debugPrint('_loadInitialState 시작');

      var permissionStatus = await Permission.contacts.status;
      debugPrint('초기 권한 상태: ${permissionStatus.toString()}');

      if (permissionStatus.isDenied) {
        debugPrint('권한 요청 시도');
        permissionStatus = await Permission.contacts.request();
        debugPrint('권한 요청 결과: ${permissionStatus.toString()}');
      }

      if (permissionStatus.isPermanentlyDenied) {
        debugPrint('설정에서 권한 확인 필요');
        try {
          if (await FlutterContacts.requestPermission()) {
            debugPrint('연락처 접근 성공');
            permissionStatus = await Permission.contacts.status;  // 상태 재확인
          }
        } catch (e) {
          debugPrint('연락처 접근 시도 중 에러: $e');
        }
      }

      if (permissionStatus.isGranted || await FlutterContacts.requestPermission()) {
        debugPrint('권한이 허용됨, 토글 ON으로 설정');
        await userService.updateMyProfile(EditMyProfile(isContactAgree: true));
        await prefs.setBool(AppConstants.isContactAgree, true);
        setState(() {
          _isToggled = true;
        });
      } else {
        debugPrint('권한이 거부됨, 토글 OFF로 설정');
        await userService.updateMyProfile(EditMyProfile(isContactAgree: false));
        await prefs.setBool(AppConstants.isContactAgree, false);
        setState(() {
          _isToggled = false;
        });
      }

      String? savedPhone = prefs.getString(AppConstants.phoneNumber);
      if (savedPhone != null) {
        setState(() {
          phone = formatPhoneNumber(savedPhone);
        });
      }
    } catch (e) {
      debugPrint('초기 상태 로드 중 오류 발생: $e');
      debugPrint(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      if (state == AppLifecycleState.resumed) {
        debugPrint('앱 라이프사이클 상태 변경: resumed');
        _loadInitialState();
      }
    } catch (e) {
      debugPrint('라이프사이클 상태 변경 처리 중 오류: $e');
    }
  }

  Future<void> _updateContactAgree(bool value) async {
    debugPrint('토글 상태 변경 시도: $value');

    if (value) {
      try {
        var status = await Permission.contacts.request();
        debugPrint('권한 요청 결과: $status');

        if (status.isGranted) {
          await userService.updateMyProfile(EditMyProfile(isContactAgree: true));
          await prefs.setBool(AppConstants.isContactAgree, true);
          setState(() {
            _isToggled = true;
          });
        } else {
          if (status.isPermanentlyDenied) {
            await openAppSettings();
          }
          setState(() {
            _isToggled = false;
          });
        }
      } catch (e) {
        debugPrint('권한 요청 중 에러 발생: $e');
        setState(() {
          _isToggled = false;
        });
      }
    } else {
      try {
        debugPrint('토글 OFF 처리 시작');

        await openAppSettings();

        await userService.updateMyProfile(EditMyProfile(isContactAgree: false));
        await prefs.setBool(AppConstants.isContactAgree, false);

        setState(() {
          _isToggled = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          var currentStatus = await Permission.contacts.status;
          debugPrint('권한 상태 재확인: $currentStatus');
          if (currentStatus.isGranted) {
            setState(() {
              _isToggled = true;
            });
          }
        });
      } catch (e) {
        debugPrint('토글 OFF 처리 중 에러 발생: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorSchemes.gray000,
        appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
        body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: StyleConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 26.h),
                    Text('계정정보 관리',
                        style: Theme.of(context)
                            .textTheme
                            .smallHeadLine3
                            .copyWith(color: ColorSchemes.orange200)),
                    SizedBox(height: 22.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                        bottom:
                            BorderSide(color: ColorSchemes.gray100, width: 1.w),
                      )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 24.r,
                                    height: 24.r,
                                    child: Center(
                                        child: SvgPicture.asset(IconPath.call,
                                            width: 16.r))),
                                SizedBox(width: 2.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('휴대폰 번호',
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .copyWith(
                                                color: ColorSchemes.gray500)),
                                    SizedBox(height: 8.h),
                                    Text(phone,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body3
                                            .copyWith(
                                                color: ColorSchemes.gray200)),
                                  ],
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  Routes.navigateTo(
                                      context, Routes.changeNumberScreen);
                                },
                                child: Text(
                                  '변경',
                                  style: Theme.of(context)
                                      .textTheme
                                      .smallHeadLine3
                                      .copyWith(color: ColorSchemes.orange200),
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SettingMenu.toggle(
                        menu: '연락처 동기화',
                        icon: IconPath.phoneEnabled,
                        iconWidth: 21.r,
                        isToggled: _isToggled,
                        onToggleChanged: (value) {
                          _updateContactAgree(value);
                        })
                  ],
                ),
              ),
            );
  }
}
