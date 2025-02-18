import 'package:flutter/material.dart';
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

class _CommonSettingScreenState extends State<CommonSettingScreen> {
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
    _isToggled = prefs.getBool(AppConstants.isContactAgree)!;

    String? savedPhone = prefs.getString(AppConstants.phoneNumber);

    if (savedPhone != null) {
      phone = formatPhoneNumber(savedPhone);
    } else {
      phone = '';
    }
  }

  Future<void> _updateContactAgree(bool value) async {
    print('토글 상태 변경 시도: $value');

    if (value) {
      try {
        // 먼저 권한 요청
        var status = await Permission.contacts.request();
        print('권한 요청 직후 상태: $status');

        // 권한 상태 다시 확인 (iOS에서 중요)
        status = await Permission.contacts.status;

        if (status.isGranted) {
          await userService.updateMyProfile(EditMyProfile(isContactAgree: value));
          await prefs.setBool(AppConstants.isContactAgree, value);
          setState(() {
            _isToggled = value;
          });
        } else {
          print('권한이 거부됨, openAppSettings 시도');
          await openAppSettings();

          // 권한 설정 변경 후 앱으로 돌아왔을 때 권한 상태 다시 확인
          status = await Permission.contacts.status;
          if (status.isGranted) {
            await userService.updateMyProfile(EditMyProfile(isContactAgree: value));
            await prefs.setBool(AppConstants.isContactAgree, value);
            setState(() {
              _isToggled = value;
            });
          } else {
            setState(() {
              _isToggled = false;
            });
          }
        }
      } catch (e) {
        print('권한 요청 중 에러 발생: $e');
        setState(() {
          _isToggled = false;
        });
      }
    } else {
      await userService.updateMyProfile(EditMyProfile(isContactAgree: value));
      await prefs.setBool(AppConstants.isContactAgree, value);
      setState(() {
        _isToggled = value;
      });
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
