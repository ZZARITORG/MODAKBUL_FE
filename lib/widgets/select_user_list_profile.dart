import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class SelectUserListProfile extends StatelessWidget {
  final String userName;
  final String userId;
  final String profileImage;
  final bool isChecked;

  const SelectUserListProfile({
    Key? key,
    required this.userName,
    required this.userId,
    required this.profileImage,
    required this.isChecked,
  }) : super(key: key);

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
                  backgroundColor: ColorSchemes.gray500,
                  child: ClipOval(
                      child: CachedNetworkImage(imageUrl: profileImage!)),
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
          SizedBox(
            height: 28.r,
            width: 28.r,
            child: Center(
              child: SvgPicture.asset(
                isChecked ? IconPath.checkCircleActivate : IconPath.checkCircleLineBlank,
                width: 28.r,
              ),
            ),
          )
        ],
      ),
    );
  }
}