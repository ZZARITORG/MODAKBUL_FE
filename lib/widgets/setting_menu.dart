import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class SettingMenu extends StatelessWidget {
  final String menu;
  final VoidCallback? onPressed;
  final String icon;

  const SettingMenu({
    Key? key,
    required this.menu,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ColorSchemes.gray100, width: 1.w),
          )),
      child: Container(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: SvgPicture.asset(icon, fit: BoxFit.scaleDown)),
                SizedBox(width: 2.w),
                Text(menu,
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: ColorSchemes.gray500)),
              ],
            ),
            Text('0.1.0',
                style: Theme.of(context)
                    .textTheme
                    .body3
                    .copyWith(color: ColorSchemes.gray300)),
          ],
        ),
      ),
    );
  }
}