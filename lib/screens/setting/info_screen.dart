import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/setting_menu.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26.h),
            Text(
              '정보',
              style: Theme.of(context)
                  .textTheme
                  .smallHeadLine3
                  .copyWith(color: ColorSchemes.orange200),
            ),
            SizedBox(height: 28.h),
            SettingMenu.arrow(
                menu: '정보수집 및 오류 보고',
                icon: IconPath.mail,
                iconWidth: 18.r,
                onPressed: () {}),
            SizedBox(height: 28.h),
            SettingMenu.version(
                menu: '버전 정보',
                icon: IconPath.mail,
                iconWidth: 18.r),
          ],
        ),
      ),
    );
  }
}
