import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

import '../constants/assets_path.dart';

class UserListProfile extends StatelessWidget {
  final bool isButton;
  final String? profileImage;
  final String userName;
  final String userId;
  final VoidCallback? onIconPressed;


  const UserListProfile({
    Key? key,
    this.isButton = true,
    this.profileImage,
    required this.userName,
    required this.userId,
    this.onIconPressed,
  }) : super(key: key);

  factory UserListProfile.icon(
      {required String userName, required String userId}) =>
      UserListProfile(
        isButton: false,
        userName: userName,
        userId: userId,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: StyleConstants.circleSizeS,
                  backgroundImage: NetworkImage(profileImage!),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .smallHeadLine3
                            .copyWith(color: ColorSchemes.gray500),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userId,
                          style: Theme.of(context)
                              .textTheme
                              .body3
                              .copyWith(color: ColorSchemes.gray300),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 32.w,),
          if (isButton)
            SizedBox(
              height: 24.r,
              width: 24.r,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onIconPressed,
                  icon: SvgPicture.asset(
                    IconPath.moreHorizontal,
                    width: 20.r,
                    fit: BoxFit.scaleDown,
                  )),
            ),
          if (!isButton)
            SizedBox(
              width: 81.w,
              height: 34.h,
              child: CustomButton(
                  text: '차단해제',
                  onPressed: () {},
                  buttonColor: ColorSchemes.orange100,
                  textStyle: Theme.of(context).textTheme.body3,
                  textColor: ColorSchemes.white),
            ),
        ],
      ),
    );
  }
}
