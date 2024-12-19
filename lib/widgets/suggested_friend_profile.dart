import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

import 'package:modakbul/themes/color_schemes.dart';

class SuggestedFriendProfile extends StatelessWidget {
  final String? profileImage;
  final String userName;
  final String mutualFriendCount;

  const SuggestedFriendProfile({
    Key? key,
    this.profileImage,
    required this.userName,
    required this.mutualFriendCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: StyleConstants.circleSizeL,
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  userName,
                  style: Theme.of(context)
                      .textTheme
                      .smallHeadLine3
                      .copyWith(color: ColorSchemes.gray500),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  '함께 아는 친구 ${mutualFriendCount}명',
                  style: Theme.of(context)
                      .textTheme
                      .body3
                      .copyWith(color: ColorSchemes.gray300),
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: CustomButton(
                          text: '친구추가',
                          onPressed: () {},
                          buttonColor: ColorSchemes.orange200,
                          textStyle: Theme.of(context).textTheme.body3,
                          textColor: ColorSchemes.white),
                    ),
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: CustomButton(
                          text: '삭제',
                          onPressed: () {},
                          buttonColor: ColorSchemes.gray100,
                          textStyle: Theme.of(context).textTheme.body3,
                          textColor: ColorSchemes.gray400),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
