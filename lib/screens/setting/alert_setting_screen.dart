import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/setting_menu.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/main.dart';

class AlertSettingScreen extends StatefulWidget {
  const AlertSettingScreen({super.key});

  @override
  State<AlertSettingScreen> createState() => _AlertSettingScreenState();
}

class _AlertSettingScreenState extends State<AlertSettingScreen> {
  bool? _isAllAlertToggled;
  bool? _isModakbulAlertToggled;
  bool? _isAdAlertToggled;

  @override
  void initState() {
    super.initState();
       _isAllAlertToggled = prefs.getBool(AppConstants.isAllAlertToggled);
       _isModakbulAlertToggled = prefs.getBool(AppConstants.isModakbulAlertToggled);
       _isAdAlertToggled = prefs.getBool(AppConstants.isAdAlertToggled);
  } // value 불러오기

  Future<void> _updateAllAlerts(bool value) async {
    setState(() {
      _isAllAlertToggled = value;
      _isModakbulAlertToggled = value;
      _isAdAlertToggled = value;
    });

    if (value) {
      await Future.wait([
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.modakbulAlertTopic),
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.adAlertTopic),
      ]);
    } else {
      await Future.wait([
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.modakbulAlertTopic),
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.adAlertTopic),
      ]);
    }
    await Future.wait([
      prefs.setBool(AppConstants.isAllAlertToggled, value),
      prefs.setBool(AppConstants.isModakbulAlertToggled, value),
      prefs.setBool(AppConstants.isAdAlertToggled, value),
    ]);
  }

  Future<void> _updateModakbulAlert(bool value) async {
    setState(() {
      _isModakbulAlertToggled = value;
      _isAllAlertToggled = _isModakbulAlertToggled! && _isAdAlertToggled!;
    });

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic(AppConstants.modakbulAlertTopic);
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.modakbulAlertTopic);
    }
    await Future.wait([
      prefs.setBool(AppConstants.isAllAlertToggled, _isAllAlertToggled!),
      prefs.setBool(AppConstants.isModakbulAlertToggled, value),
    ]);
  }

  Future<void> _updateAdAlert(bool value) async {
    setState(() {
      _isAdAlertToggled = value;
      _isAllAlertToggled = _isModakbulAlertToggled! && _isAdAlertToggled!;
    });

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic(AppConstants.adAlertTopic);
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.adAlertTopic);
    }
    await Future.wait([
      prefs.setBool(AppConstants.isAllAlertToggled, _isAllAlertToggled!),
      prefs.setBool(AppConstants.isAdAlertToggled, value),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
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
                isToggled: _isAllAlertToggled!,
                onToggleChanged: _updateAllAlerts),
            SizedBox(height: 28.h),
            SettingMenu.toggle(
                menu: '모닥불 초대 알림 끄기',
                icon: IconPath.notificationsOff,
                iconWidth: 14.r,
                isToggled: _isModakbulAlertToggled!,
                onToggleChanged: _updateModakbulAlert),
            SizedBox(height: 28.h),
            SettingMenu.toggle(
                menu: '광고성 알림 끄기',
                icon: IconPath.notificationsOff,
                iconWidth: 14.r,
                isToggled: _isAdAlertToggled!,
                onToggleChanged: _updateAdAlert),
          ],
        ),
      ),
    );
  }
}
