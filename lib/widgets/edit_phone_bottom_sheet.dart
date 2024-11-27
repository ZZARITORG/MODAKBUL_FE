import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class EditPhoneBottomSheet extends StatelessWidget {
  const EditPhoneBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorSchemes.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(StyleConstants.radiusLarge)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: StyleConstants.defaultPadding,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 38.h),
                Text('정말 번호를 변경하시겠습니까?',
                    style: Theme.of(context)
                        .textTheme
                        .bigHeadLine3
                        .copyWith(color: ColorSchemes.orange200)),
                SizedBox(height: 12.h),
                Text('번호를 변경하면 기존 번호로 로그인이 불가능하며\n변경 시 로그아웃 됩니다.',
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: ColorSchemes.gray300, height: 26.h / 16.sp)),
                SizedBox(height: 29.h),
                SizedBox(
                  height: 56.h,
                  width: double.infinity,
                  child: CustomButton(
                      text: '변경 완료',
                      onPressed: (){},
                      buttonColor: ColorSchemes.orange200,
                      textStyle: Theme.of(context).textTheme.smallHeadLine2,
                      textColor: ColorSchemes.white),
                ),
                SizedBox(height: 16.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
