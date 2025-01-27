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

class CommonSettingScreen extends StatefulWidget {
  const CommonSettingScreen({super.key});

  @override
  State<CommonSettingScreen> createState() => _CommonSettingScreenState();
}

class _CommonSettingScreenState extends State<CommonSettingScreen> {
  bool _isToggled = false;
  UserService userService = UserService();
  ///late Future<MyProfile> _futureProfile;

  @override
  void initState() {
    super.initState();
    ///_futureProfile = _loadProfile();
    _isToggled = prefs.getBool(AppConstants.isContactAgree)!;
  }

  Future<MyProfile> _loadProfile() async {
    final profile = await userService.getMyProfile();
    setState(() {
      _isToggled = profile.isContactAgree ?? false;
    });
    return profile;
  }

  Future<void> _updateContactAgree(bool value) async {
    await userService.updateMyProfile(EditMyProfile(isContactAgree: value));
    await prefs.setBool(AppConstants.isContactAgree, value);
    setState(() {
      _isToggled = value;
    });
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
                                    Text('010-0000-0000',
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
