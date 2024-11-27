import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/widgets/setting_menu.dart';

class FriendSettingScreen extends StatefulWidget {
  const FriendSettingScreen({super.key});

  @override
  State<FriendSettingScreen> createState() => _FriendSettingScreenState();
}

class _FriendSettingScreenState extends State<FriendSettingScreen> {
  bool _isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(
          backgroundColor: ColorSchemes.gray000
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26.h),
            Text(
              '친구설정',
              style: Theme.of(context)
                  .textTheme
                  .smallHeadLine3
                  .copyWith(color: ColorSchemes.orange200),
            ),
            SizedBox(height: 22.h),
            SettingMenu.toggle(
                menu: '친구 추천 허용',
                icon: IconPath.friend,
                iconWidth: 18.r,
                isToggled: _isToggled,
                onToggleChanged: (value) {
                  setState(() {
                    _isToggled = value;
                  });
                }),
            SizedBox(height: 28.h),
            SettingMenu.arrow(menu: '차단된 사용자', icon: IconPath.blockOrange100, iconWidth: 16.r, onPressed: (){})
          ],
      ),
      ),
    );
  }
}
