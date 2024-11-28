import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class ParticipateBottomSheet extends StatelessWidget {
  const ParticipateBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(StyleConstants.radiusLarge),
                topRight: Radius.circular(StyleConstants.radiusLarge),
              ),
              color: ColorSchemes.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 38.h,
              ),
              Text(
                '모닥불 참여',
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine3
                    .copyWith(color: ColorSchemes.gray500, height: 1.193, decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 12.h,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '정말로 모닥불에 참여하시겠습니까?',
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: ColorSchemes.gray400, height: 1.5, decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 57.h,
              ),
              SizedBox(
                width: double.infinity,
                  height: 56.h,
                  child: CustomButton(
                      text: '모닥불 참여',
                      onPressed: () {},
                      buttonColor: ColorSchemes.orange200,
                      textStyle: Theme.of(context).textTheme.smallHeadLine2,
                      textColor: ColorSchemes.white))
            ],
          ),
        ),
      ),
    );
  }
}
