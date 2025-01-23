import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/models/blocked_user.dart';
import 'package:modakbul/models/modakbul_detail.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/participant_bottom_sheet.dart';
import 'package:modakbul/widgets/profile_bottom_sheet.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/services/friend_service.dart';

class ModakbulDetailCard extends StatelessWidget {
  final String hostName;
  final String hostUserId;
  final String hostId;
  final int participantLength;
  final String hostProfileImage;
  final List<UserStatus> users;
  final List<UserStatus> participantUsers;
  final List<BlockedUser> blockedUsers;
  final FriendService friendService;
  final UserCheck userCheckData;
  final String myUserId;

  const ModakbulDetailCard({
    super.key,
    required this.hostName,
    required this.hostUserId,
    required this.hostId,
    required this.hostProfileImage,
    required this.participantLength,
    required this.users,
    required this.participantUsers,
    required this.blockedUsers,
    required this.friendService,
    required this.userCheckData,
    required this.myUserId,
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 232.w,
            child: GestureDetector(
              onTap: () {
                if(myUserId == hostUserId) {
                  return;
                }
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bottomSheetContext) {
                      return ProfileBottomSheet(
                          userCheckData: userCheckData,
                          selectedUserId: hostId,
                          friendService: friendService
                      );
                    }
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: StyleConstants.circleSizeXS,
                    backgroundImage: NetworkImage(hostProfileImage),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hostName,
                        style: Theme.of(context)
                            .textTheme
                            .bigHeadLine5
                            .copyWith(color: ColorSchemes.gray500, height: 1.193),
                      ),
                      Text(
                        hostUserId,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: ColorSchemes.gray300, height: 1.193),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (participantLength > 1) {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext bottomSheetContext) {
                      return ParticipantBottomSheet(users: users, hostUserId: hostUserId, blockedUsers: blockedUsers,
                        friendService: friendService, );
                    }
                );
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
                                          child: ClipOval(
                                              child: CachedNetworkImage(imageUrl: participantUsers[0].profileUrl)),
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
                                        radius:
                                            StyleConstants.circleSizeXXXXXXS,
                                        child: ClipOval(
                                            child: CachedNetworkImage(imageUrl: participantUsers[1].profileUrl)),
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
                                        radius:
                                            StyleConstants.circleSizeXXXXXXS,
                                        child: ClipOval(
                                            child: CachedNetworkImage(imageUrl: participantUsers[2].profileUrl)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            '${participantLength - 1}명',
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
