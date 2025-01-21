import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/pending_modakbul.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/themes/color_schemes.dart';

class InvitedModakbulCard extends StatelessWidget {
  final String hostProfileImage;
  final int participantLength;
  final String hostName;
  final String hostId;
  final String title;
  final String content;
  final String date;
  final String address;
  final List<UserStatus> participantUsers;

  const InvitedModakbulCard({
    Key? key,
    required this.hostProfileImage,
    required this.participantLength,
    required this.hostName,
    required this.hostId,
    required this.title,
    required this.content,
    required this.date,
    required this.address,
    required this.participantUsers,
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
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: StyleConstants.circleSizeXS,
                            backgroundImage: NetworkImage(hostProfileImage),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hostName,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .smallHeadLine3
                                      .copyWith(
                                        color: ColorSchemes.gray400,
                                      ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  hostId,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body3
                                      .copyWith(
                                        color: ColorSchemes.gray300,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32.w),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          participantLength == 1
                              ? Row(
                                  children: [
                                    Text(
                                      '참여자가 없습니다',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body3
                                          .copyWith(
                                            color: ColorSchemes.gray200,
                                          ),
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
                                      width: participantLength >= 4
                                          ? 84.w
                                          : (participantLength == 3 ? 60.w : 36.w),
                                      child: Stack(
                                        children: [
                                          if (participantLength >= 2)
                                            Positioned(
                                              child: CircleAvatar(
                                                radius: StyleConstants
                                                    .circleSizeXXXXXS,
                                                backgroundColor:
                                                    ColorSchemes.white,
                                                child: CircleAvatar(
                                                  radius: StyleConstants
                                                      .circleSizeXXXXXXS,
                                                  backgroundImage: NetworkImage(participantUsers[0].profileUrl),
                                                ),
                                              ),
                                            ),
                                          if (participantLength >= 3)
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
                                                  backgroundImage: NetworkImage(participantUsers[1].profileUrl),
                                                ),
                                              ),
                                            ),
                                          if (participantLength >= 4)
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
                                                  backgroundImage: NetworkImage(participantUsers[2].profileUrl),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 7.w),
                                    Text(
                                      '${participantLength - 1}명',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body3
                                          .copyWith(
                                            color: ColorSchemes.gray200,
                                          ),
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
                SizedBox(height: 20.h),
                // 2. 모임 제목과 설명
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .smallHeadLine1
                        .copyWith(color: ColorSchemes.gray500)),
                SizedBox(height: 8.h),
                Text(
                  content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .body3
                      .copyWith(color: ColorSchemes.gray300, height: 24 / 14),
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
                              width: 16.r)),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      date,
                      style: Theme.of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.orange200),
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
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.orange200),
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
