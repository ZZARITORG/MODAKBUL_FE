import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class ChangePhoneBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  const ChangePhoneBottomSheet({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
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
                '정말 번호를 변경하시겠습니까?',
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine3
                    .copyWith(color: ColorSchemes.orange200, height: 1.193, decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 12.h,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '번호를 변경하면 기존 번호로 로그인이 불가능하며\n변경 시 로그아웃 됩니다.',
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: ColorSchemes.gray300, height: 1.625, decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 29.h,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: CustomButton(
                      text: '변경완료',
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
