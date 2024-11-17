import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class UserListProfile extends StatelessWidget {
  final bool isButton;
  final String? profileImage;
  final String userName;
  final String userId;

  const UserListProfile({
    Key? key,
    this.isButton = true,
    this.profileImage,
    required this.userName,
    required this.userId,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: StyleConstants.circleSizeS,
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: Theme.of(context)
                        .textTheme
                        .smallHeadLine3
                        .copyWith(color: ColorSchemes.gray500),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    userId,
                    style: Theme.of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.gray300),
                  ),
                ],
              ),
              if (isButton)
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
              if (!isButton)
                SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        IconPath.moreHorizontal,
                        width: 20.r,
                      ),
                    )),
            ],
          ),
        )
      ],
    );
  }
}
