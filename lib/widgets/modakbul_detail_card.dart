import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import '../constants/assets_path.dart';
import '../constants/style_constants.dart';

class ModakbulDetailCard extends StatelessWidget {
  final String userName;
  final String userId;
  final int profileLength;
  final String posterProfileImage;
  final String participantProfileImage;

  const ModakbulDetailCard({
    super.key,
    required this.userName,
    required this.userId,
    required this.posterProfileImage,
    required this.profileLength,
    required this.participantProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 232.w,
            child: Row(
              children: [
                CircleAvatar(
                  radius: StyleConstants.circleSizeXS,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.bigHeadLine5.copyWith(
                            color: ColorSchemes.gray500,
                          ),
                    ),
                    Text(
                      userId,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: ColorSchemes.gray300,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                profileLength == 1
                    ? Row(
                        children: [
                          Text(
                            '참여자가 없습니다',
                            style: Theme.of(context).textTheme.body3.copyWith(
                                color: ColorSchemes.gray200, height: 1.571),
                          ),
                          SizedBox(width: 6.w),
                          SvgPicture.asset(IconPath.arrowForward15Gray200,
                              width: 8.r),
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: profileLength >= 4
                                ? 84.w
                                : (profileLength == 3 ? 60.w : 36.w),
                            child: Stack(
                              children: [
                                if (profileLength >= 2)
                                  Positioned(
                                    child: CircleAvatar(
                                      radius: StyleConstants.circleSizeXXXXXS,
                                      backgroundColor: ColorSchemes.white,
                                      child: CircleAvatar(
                                        radius:
                                            StyleConstants.circleSizeXXXXXXS,
                                        backgroundColor: ColorSchemes.orange200,
                                      ),
                                    ),
                                  ),
                                if (profileLength >= 3)
                                  Positioned(
                                    left: 24.w,
                                    child: CircleAvatar(
                                      radius: StyleConstants.circleSizeXXXXXS,
                                      backgroundColor: ColorSchemes.white,
                                      child: CircleAvatar(
                                        radius:
                                            StyleConstants.circleSizeXXXXXXS,
                                        backgroundColor: ColorSchemes.orange100,
                                      ),
                                    ),
                                  ),
                                if (profileLength >= 4)
                                  Positioned(
                                    left: 48.w,
                                    child: CircleAvatar(
                                      radius: StyleConstants.circleSizeXXXXXS,
                                      backgroundColor: ColorSchemes.white,
                                      child: CircleAvatar(
                                        radius:
                                            StyleConstants.circleSizeXXXXXXS,
                                        backgroundColor: ColorSchemes.orange000,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            '${profileLength - 1}명',
                            style: Theme.of(context).textTheme.body3.copyWith(
                                color: ColorSchemes.gray200, height: 1.571),
                          ),
                          SizedBox(width: 6.w),
                          SvgPicture.asset(IconPath.arrowForward15Gray200,
                              width: 8.r),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
