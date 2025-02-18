import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/my_host_modakbul.dart' as host_model;
import 'package:modakbul/models/modakbul_detail.dart' as detail_model;
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/participant_bottom_sheet.dart';
import '../services/friend_service.dart';
import '../themes/color_schemes.dart';

class MyModakbulCard extends StatelessWidget {
  final int participantLength;
  final String title;
  final String groupName;
  final String date;
  final String location;
  final List<host_model.UserStatus> participantUsers;
  final String userId;
  final List<host_model.UserStatus> users;
  final bool isPending;
  final bool isBlocked;
  final FriendService friendService;

  const MyModakbulCard({
    Key? key,
    required this.participantLength,
    required this.title,
    required this.groupName,
    required this.date,
    required this.location,
    required this.participantUsers,
    required this.users,
    required this.isBlocked,
    required this.isPending,
    required this.userId,
    required this.friendService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupName,
          style: Theme.of(context)
              .textTheme
              .body3
              .copyWith(color: ColorSchemes.orange200),
        ),
        SizedBox(
          height: 4.h,
        ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bigHeadLine3
                .copyWith(color: ColorSchemes.gray500),
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: SvgPicture.asset(
                IconPath.timeOrange100,
                width: 16.r,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              date,
              style: Theme.of(context)
                  .textTheme
                  .body3
                  .copyWith(color: ColorSchemes.orange100),
            )
          ],
        ),
        SizedBox(
          height: 6.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: SvgPicture.asset(
                IconPath.pinDropOrange100,
                width: 16.r,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              location,
              style: Theme.of(context)
                  .textTheme
                  .body3
                  .copyWith(color: ColorSchemes.orange100),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: ColorSchemes.orange200),
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              child: Text(
                '내가 피운 모닥불',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: ColorSchemes.white),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (participantLength > 1) {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext bottomSheetContext) {
                        return ParticipantBottomSheet(
                          users: users.map((user) => detail_model.UserStatus(
                            id: user.id,
                            userId: user.userId,
                            name: user.name,
                            profileUrl: user.profileUrl,
                            status: user.status,
                          )).toList(),
                          hostUserId: userId,
                          blockedUsers: const [],
                          friendService: friendService,
                          myUserId: userId,
                        );
                      });
                }
              },
              child: Row(
                children: [
                  participantLength == 1
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
                              width: participantLength >= 4
                                  ? 84.w
                                  : (participantLength == 3 ? 60.w : 36.w),
                              child: Stack(
                                children: [
                                  if (participantLength >= 2)
                                    Positioned(
                                      child: CircleAvatar(
                                        radius: StyleConstants.circleSizeXXXXXS,
                                        backgroundColor: ColorSchemes.white,
                                        child: CircleAvatar(
                                          radius:
                                              StyleConstants.circleSizeXXXXXXS,
                                          backgroundColor: ColorSchemes.gray200,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                                  imageUrl: participantUsers[0]
                                                      .profileUrl)),
                                        ),
                                      ),
                                    ),
                                  if (participantLength >= 3)
                                    Positioned(
                                      left: 24.w,
                                      child: CircleAvatar(
                                        radius: StyleConstants.circleSizeXXXXXS,
                                        backgroundColor: ColorSchemes.white,
                                        child: CircleAvatar(
                                          backgroundColor: ColorSchemes.gray200,
                                          radius:
                                              StyleConstants.circleSizeXXXXXXS,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                                  imageUrl: participantUsers[1]
                                                      .profileUrl)),
                                        ),
                                      ),
                                    ),
                                  if (participantLength >= 4)
                                    Positioned(
                                      left: 48.w,
                                      child: CircleAvatar(
                                        radius: StyleConstants.circleSizeXXXXXS,
                                        backgroundColor: ColorSchemes.white,
                                        child: CircleAvatar(
                                          backgroundColor: ColorSchemes.gray200,
                                          radius:
                                              StyleConstants.circleSizeXXXXXXS,
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                                  imageUrl: participantUsers[2]
                                                      .profileUrl)),
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
                                  .copyWith(color: ColorSchemes.gray200),
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
        )
      ],
    );
  }
}
