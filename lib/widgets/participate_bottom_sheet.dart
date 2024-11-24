import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

import '../themes/color_schemes.dart';

class ParticipateBottomSheet extends StatelessWidget {
  const ParticipateBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 269.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
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
          Text(
            '정말로 모닥불에 참여하시겠습니까?',
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: ColorSchemes.gray400, height: 1.5, decoration: TextDecoration.none),
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
    );
  }
}
