import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class SettingMenu extends StatelessWidget {
  final String menu;
  final VoidCallback? onPressed;
  final String icon;
  final Widget? trailingWidget;
  final double? iconWidth;
  final double? iconHeight;

  const SettingMenu(
      {Key? key,
      required this.menu,
      required this.onPressed,
      required this.icon,
      this.iconWidth,
      this.iconHeight,
      this.trailingWidget})
      : super(key: key);

  factory SettingMenu.arrow({
    required String menu,
    required String icon,
    required double iconWidth,
    double? iconHeight,
    VoidCallback? onPressed,
  }) =>
      SettingMenu(
        menu: menu,
        icon: icon,
        onPressed: onPressed,
        iconWidth: iconWidth,
        iconHeight: iconHeight,
        trailingWidget: Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: SvgPicture.asset(
            IconPath.arrowForward15Gray200,
            width: 8.r,
          ),
        ),
      );

  factory SettingMenu.toggle({
    required String menu,
    required String icon,
    required double iconWidth,
    double? iconHeight,
    required bool isToggled,
    required ValueChanged<bool> onToggleChanged,
    Color? activeColor, // 스위치 On 상태 색상
  }) =>
      SettingMenu(
        menu: menu,
        icon: icon,
        iconWidth: iconWidth,
        iconHeight: iconHeight,
        trailingWidget: Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: Switch(
            value: isToggled,
            onChanged: onToggleChanged,
            activeColor: activeColor ?? ColorSchemes.orange200,
          ),
        ),
        onPressed: () {},
      );

  factory SettingMenu.version({
    required String menu,
    required String icon,
    required double iconWidth,
    double? iconHeight,
    VoidCallback? onPressed,
  }) =>
      SettingMenu(
        menu: menu,
        icon: icon,
        iconWidth: iconWidth,
        iconHeight: iconHeight,
        onPressed: onPressed,
        trailingWidget:
            Padding(padding: EdgeInsets.only(right: 2.w), child: Text('0.1.0')),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(ColorSchemes.orange000),
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: ColorSchemes.gray100, width: 1.w),
        )),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: Center(
                          child: SvgPicture.asset(icon,
                              width: iconWidth, height: iconHeight))),
                  SizedBox(width: 2.w),
                  Text(menu,
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: ColorSchemes.gray500)),
                ],
              ),
              if (trailingWidget != null)
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.gray300),
                    child: trailingWidget!)
            ],
          ),
        ),
      ),
    );
  }
}
