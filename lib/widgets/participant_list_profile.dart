import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';

import 'package:modakbul/themes/color_schemes.dart';

class Participantlistprofile extends StatelessWidget {
  final String? profileImage;
  final String userName;
  final String userId;

  const Participantlistprofile({
    Key? key,
    this.profileImage,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: StyleConstants.circleSizeS,
        ),
        SizedBox(
          width: 6.w,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: Theme.of(context)
                    .textTheme
                    .smallHeadLine2
                    .copyWith(color: ColorSchemes.gray500),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                userName,
                style: Theme.of(context)
                    .textTheme
                    .body3
                    .copyWith(color: ColorSchemes.gray300),
              ),
            ],
          ),
        )
      ],
    );
  }
}
