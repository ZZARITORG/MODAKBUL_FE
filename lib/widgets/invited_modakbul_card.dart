import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      color:Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StyleConstants.radiusMedium)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            .copyWith(color: ColorSchemes.gray400),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        userId,
                        style: Theme.of(context)
                            .textTheme
                            .body3
                            .copyWith(color: ColorSchemes.gray300),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  profileLength == 1
                      ? Center(
                          child: Text(
                            '참여자가 없습니다',
                            style: Theme.of(context)
                                .textTheme
                                .body3
                                .copyWith(color: ColorSchemes.gray200),
                          ),
                        )
                      : SizedBox(
                    width: profileLength >= 4 ? 84.w : (profileLength == 3 ? 60.w : 36.w),
                    child: Stack(

                            children: [
                              if (profileLength >= 2)
                                Positioned(


                                  child: CircleAvatar(
                                    radius: StyleConstants.circleSizeXXXXXS,
                                    backgroundColor: ColorSchemes.white,
                                    child: CircleAvatar(
                                      radius: StyleConstants.circleSizeXXXXXXS,
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
                                      radius: StyleConstants.circleSizeXXXXXXS,
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
                                      radius: StyleConstants.circleSizeXXXXXXS,
                                      backgroundColor: ColorSchemes.orange000,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ),
                  SizedBox(width: 7.w),
                  Text('${profileLength-1}명',
                      style: Theme.of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.gray200)),
                  SizedBox(width: 6.w),
                  IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: SvgPicture.asset('assets/icons/Vector 7.svg'))
                ], //children
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
                    .copyWith(color: ColorSchemes.gray500)),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 329.w,
            child: Text(description,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .body3
                    .copyWith(color: ColorSchemes.gray300)),
          ),
          SizedBox(height: 16.h),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: ColorSchemes.gray100,
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
                width: 20.w,
                child: SvgPicture.asset('assets/icons/Group 3336.svg'),
              ),
              SizedBox(width: 4.w),
              Text(date,
                  style: Theme.of(context)
                      .textTheme
                      .body3
                      .copyWith(color: ColorSchemes.orange200)),
              SizedBox(height: 6.h),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
                width: 20.w,
                child: SvgPicture.asset('assets/icons/Subtract.svg'),
              ),
              SizedBox(width: 4.w),
              Text(location,
                  style: Theme.of(context)
                      .textTheme
                      .body3
                      .copyWith(color: ColorSchemes.orange200)),
            ],
          ),
        ]),
      ),
    );
  }
}
