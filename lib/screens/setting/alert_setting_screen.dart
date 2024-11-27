import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/setting_menu.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';

class AlertSettingScreen extends StatefulWidget {
  const AlertSettingScreen({super.key});

  @override
  State<AlertSettingScreen> createState() => _AlertSettingScreenState();
}

class _AlertSettingScreenState extends State<AlertSettingScreen> {
  bool _isAllAlertToggled = false;
  bool _isModakbulAlertToggled = false;
  bool _isAdAlertToggled = false;

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
            Text('알림설정',
                style: Theme.of(context)
                    .textTheme
                    .smallHeadLine3
                    .copyWith(color: ColorSchemes.orange200)),
            SizedBox(height: 22.h),
            SettingMenu.toggle(
                menu: '전체 알림 끄기',
                icon: IconPath.notificationsOff,
                iconWidth: 14.r,
                isToggled: _isAllAlertToggled,
                onToggleChanged: (value) {
                  setState(() {
                    _isAllAlertToggled = value;
                  });
                }),
            SizedBox(height: 28.h),
            SettingMenu.toggle(
                menu: '모닥불 초대 알림 끄기',
                icon: IconPath.notificationsOff,
                iconWidth: 14.r,
                isToggled: _isModakbulAlertToggled,
                onToggleChanged: (value) {
                  setState(() {
                    _isModakbulAlertToggled = value;
                  });
                }),
            SizedBox(height: 28.h),
            SettingMenu.toggle(
                menu: '광고성 알림 끄기',
                icon: IconPath.notificationsOff,
                iconWidth: 14.r,
                isToggled: _isAdAlertToggled,
                onToggleChanged: (value) {
                  setState(() {
                    _isAdAlertToggled = value;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
