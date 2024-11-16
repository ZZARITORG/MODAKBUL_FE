import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import '../themes/color_schemes.dart';

class InvitedModakbulCard extends StatelessWidget {
  final String? profileImage1;
  final String? profileImage2;
  final int profileLength;
  final String userName;
  final String userId;
  final String title;
  final String description;
  final String date;
  final String location;

  const InvitedModakbulCard({
    Key? key,
    this.profileImage1,
    this.profileImage2,
    required this.profileLength,
    required this.userName,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StyleConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 상단 사용자 정보 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: StyleConstants.circleSizeXS,
                        ),
                        SizedBox(width: 4.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .smallHeadLine3
                                  .copyWith(
                                      color: ColorSchemes.gray400,
                                      height: 1.193),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              userId,
                              style: Theme.of(context).textTheme.body3.copyWith(
                                  color: ColorSchemes.gray300, height: 1.571),
                            ),
                          ],
                        ),
                      ],
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .body3
                                          .copyWith(
                                              color: ColorSchemes.gray200,
                                              height: 1.571),
                                    ),
                                    SizedBox(width: 6.w),
                                    SvgPicture.asset(
                                        IconPath.arrowForward15Gray200,
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
                                                radius: StyleConstants
                                                    .circleSizeXXXXXS,
                                                backgroundColor:
                                                    ColorSchemes.white,
                                                child: CircleAvatar(
                                                  radius: StyleConstants
                                                      .circleSizeXXXXXXS,
                                                  backgroundColor:
                                                      ColorSchemes.orange200,
                                                ),
                                              ),
                                            ),
                                          if (profileLength >= 3)
                                            Positioned(
                                              left: 24.w,
                                              child: CircleAvatar(
                                                radius: StyleConstants
                                                    .circleSizeXXXXXS,
                                                backgroundColor:
                                                    ColorSchemes.white,
                                                child: CircleAvatar(
                                                  radius: StyleConstants
                                                      .circleSizeXXXXXXS,
                                                  backgroundColor:
                                                      ColorSchemes.orange100,
                                                ),
                                              ),
                                            ),
                                          if (profileLength >= 4)
                                            Positioned(
                                              left: 48.w,
                                              child: CircleAvatar(
                                                radius: StyleConstants
                                                    .circleSizeXXXXXS,
                                                backgroundColor:
                                                    ColorSchemes.white,
                                                child: CircleAvatar(
                                                  radius: StyleConstants
                                                      .circleSizeXXXXXXS,
                                                  backgroundColor:
                                                      ColorSchemes.orange000,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 7.w),
                                    Text(
                                      '${profileLength - 1}명',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body3
                                          .copyWith(
                                              color: ColorSchemes.gray200,
                                              height: 1.571),
                                    ),
                                    SizedBox(width: 6.w),
                                    SvgPicture.asset(
                                        IconPath.arrowForward15Gray200,
                                        width: 8.r),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // 2. 모임 제목과 설명
                SizedBox(
                  width: 329.w,
                  child: Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .smallHeadLine1
                          .copyWith(
                              color: ColorSchemes.gray500, height: 1.194)),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 329.w,
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.gray300, height: 1.714),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: ColorSchemes.gray100,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.r,
                      width: 20.r,
                      child: Center(
                          child: SvgPicture.asset(IconPath.timeOrange200,
                              width: 20.r)),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.body3.copyWith(
                          color: ColorSchemes.orange200, height: 1.571),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.r,
                      width: 20.r,
                      child: Center(
                          child: SvgPicture.asset(IconPath.pinDropOrange200,
                              width: 12.r)),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      location,
                      style: Theme.of(context).textTheme.body3.copyWith(
                          color: ColorSchemes.orange200, height: 1.571),
                    ),
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
