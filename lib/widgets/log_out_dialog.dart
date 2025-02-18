import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/themes/color_schemes.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 81.5.w),
              child: Column(
                children: [
                  SizedBox(height: 27.h),
                  Text('로그아웃 되었습니다.',
                      style: Theme.of(context)
                          .textTheme
                          .smallHeadLine2
                          .copyWith(color: ColorSchemes.orange200)),
                  SizedBox(height: 14.h),
                  Text('다시 로그인 해주세요.',
                      style: Theme.of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.gray400)),
                  SizedBox(height: 22.h)
                ],
              ),
            ),
            Divider(
                thickness: 1,
                height: 1.h,
                color: Color(0xFFF1F1F1)
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {

              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.splashScreen,
                      (route) => false
              );
            },
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.5.h),
              alignment: Alignment.center,
              child: Text(
                '확인',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: ColorSchemes.gray500),
              ),
            ),
          ),
        ]
    );
  }
}