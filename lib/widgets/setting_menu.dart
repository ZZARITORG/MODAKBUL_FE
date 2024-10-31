import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class SettingMenu extends StatelessWidget {
  final String menu;
  final VoidCallback? onPressed;

  const SettingMenu({
    Key? key,
    required this.menu,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 361.w,
      height: 35.h,
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
                SvgPicture.asset('assets/icons/Rectangle 97.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 9.w),
                  child: Text(menu,
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: ColorSchemes.gray500)),
                ),
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