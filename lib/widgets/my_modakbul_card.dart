import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import '../themes/color_schemes.dart';

class MyModakbulCard extends StatelessWidget {
  final String? profileImage1;
  final String? profileImage2;
  final int profileLength;
  final String userName;
  final String userId;
  final String title;
  final String description;
  final String date;
  final String location;

  const MyModakbulCard({
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
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 상단 사용자 정보 영역
                // 2. 모임 제목과 설명
                SizedBox(
                  width: 329.w,
                  child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme
                          .of(context)
                          .textTheme
                          .smallHeadLine1
                          .copyWith(color: ColorSchemes.gray500,
                          height:1.194)
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 329.w,
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.gray300,
                        height:1.714),
                  ),
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
          Container(
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
                        child: SvgPicture.asset(IconPath.timeOrange100, width: 16.r,),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      date,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.orange200,
                          height:1.571),
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
                        child: SvgPicture.asset(IconPath.pinDropOrange100, width: 12.r),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      location,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.orange200,
                          height:1.571),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 12.h),
                decoration: BoxDecoration(
                  color: ColorSchemes.orange200,
                  borderRadius: BorderRadius.circular(15.r)
                ),
                child: Text(
                  '내가 피운 모닥불',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: ColorSchemes.white)
                ),
              ),
              Row(
                children: [
                  profileLength == 1
                      ? Row(
                    children: [
                      Text(
                        '참여자가 없습니다',
                        style: Theme
                            .of(context)
                            .textTheme
                            .body3
                            .copyWith(color: ColorSchemes.gray200,
                            height:1.571),
                      ),
                      SizedBox(width: 6.w),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset(
                            'assets/icons/Vector 7.svg'),
                      ),
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
                        style: Theme
                            .of(context)
                            .textTheme
                            .body3
                            .copyWith(color: ColorSchemes.gray200,
                            height:1.571),
                      ),
                      SizedBox(width: 6.w),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset(IconPath.arrowForward15Gray200, width: 6.r,),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}