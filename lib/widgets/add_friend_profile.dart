import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

import 'package:modakbul/themes/color_schemes.dart';

class AddFriendProfile extends StatelessWidget {
  final String? profileImage;
  final String userName;
  final String userId;
  final String time;
  final VoidCallback acceptOnPressed;
  final VoidCallback rejectOnPressed;

  const AddFriendProfile({
    Key? key,
    this.profileImage,
    required this.userName,
    required this.userId,
    required this.time,
    required this.acceptOnPressed,
    required this.rejectOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: StyleConstants.circleSizeL,
          backgroundImage: NetworkImage(profileImage!),
          backgroundColor: ColorSchemes.gray500,
        ),
        SizedBox(width: 12.w,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(userName, style: Theme.of(context).textTheme.smallHeadLine3.copyWith(color: ColorSchemes.gray500),),
                  ),
                  Text(time, style: Theme.of(context).textTheme.caption.copyWith(color: ColorSchemes.gray200),),
                ],
              ),
              SizedBox(height: 2.h,),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(userId, style: Theme.of(context).textTheme.body3.copyWith(color: ColorSchemes.gray300),),
              ),
              SizedBox(height: 9.h,),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: CustomButton(
                          text: '확인',
                          onPressed: acceptOnPressed,
                          buttonColor: ColorSchemes.orange200,
                          textStyle: Theme.of(context).textTheme.body3,
                          textColor: ColorSchemes.white
                      ),
                    ),
                  ),
                  SizedBox(width: 7.w,),
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: CustomButton(
                          text: '삭제',
                          onPressed: rejectOnPressed,
                          buttonColor: ColorSchemes.gray100,
                          textStyle: Theme.of(context).textTheme.body3,
                          textColor: ColorSchemes.gray400
                      ),
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
