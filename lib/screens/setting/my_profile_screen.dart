import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/log_out_dialog.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/setting_menu.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

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
                                  Positioned(
                                    child: CircleAvatar(
                                      radius: StyleConstants.circleSizeS,
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: CircleAvatar(
                                        backgroundColor: ColorSchemes.orange200,
                                        radius: StyleConstants.circleSizeXXXXXXXS,
                                        child: SvgPicture.asset(
                                            IconPath.photoCameraOrange100,
                                            width: 13.83.r),
                                      )),
                                ]),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '김지호',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bigHeadLine4
                                            .copyWith(color: ColorSchemes.gray500),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'kim_jj0_',
                                        style: Theme.of(context)
                                            .textTheme
                                            .body3
                                            .copyWith(color: ColorSchemes.gray400),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 32.w),
                          Text(
                            '수정하기',
                            style: Theme.of(context)
                                .textTheme
                                .smallHeadLine3
                                .copyWith(color: ColorSchemes.orange200),
                          )
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
                  SettingMenu.arrow(menu: '계정정보 관리', icon: IconPath.verifiedUser, iconWidth: 16.r, onPressed: () {}),
                  SizedBox(height: 18.h),
                  SettingMenu.arrow(menu: '알림설정', icon: IconPath.notificationsBell, iconWidth: 13.r, onPressed: () {}),
                  SizedBox(height: 18.h),
                  SettingMenu.arrow(menu: '친구설정', icon: IconPath.friend, iconWidth: 18.r, onPressed: () {}),
                  SizedBox(height: 32.h),
                  Text(
                    '보안',
                    style: Theme.of(context)
                        .textTheme
                        .smallHeadLine3
                        .copyWith(color: ColorSchemes.orange200),
                  ),
                  SizedBox(height: 14.h),
                  SettingMenu.arrow(menu: '이용약관', iconWidth: 12.r, icon: IconPath.lock, onPressed: (){}),
                  SizedBox(height: 18.h),
                  SettingMenu.arrow(menu: '정보', iconWidth: 15.r, icon: IconPath.description, onPressed: (){}),
                ],
              ),
            ),

            Center(
              child: InkWell(
                overlayColor: WidgetStateProperty.all(ColorSchemes.orange000),
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return LogOutDialog();
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                    children: [
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
