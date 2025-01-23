import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/models/blocked_user.dart';
import 'package:modakbul/models/modakbul_detail.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/participant_list_profile.dart';

import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/profile_bottom_sheet.dart';

import '../services/friend_service.dart';
import '../services/user_service.dart';

class ParticipantBottomSheet extends StatefulWidget {
  final List<UserStatus> users;
  final String hostUserId;
  final List<BlockedUser> blockedUsers;
  final FriendService friendService;

  const ParticipantBottomSheet({
    super.key,
    required this.users,
    required this.hostUserId,
    required this.blockedUsers,
    required this.friendService,
  });

  @override
  State<ParticipantBottomSheet> createState() => _ParticipantBottomSheetState();
}

class _ParticipantBottomSheetState extends State<ParticipantBottomSheet> {
  late List<UserStatus> sortedUsers;
  late List<String> blockedUsersIds;
  final UserService userService = UserService();

  void initState() {
    super.initState();
    sortedUsers = List<UserStatus>.from(widget.users);
    sortedUsers.sort((a, b) {
      if (a.userId == widget.hostUserId) return -1;
      if (b.userId == widget.hostUserId) return 1;
      return 0;
    });
    blockedUsersIds =
        widget.blockedUsers.map((blockedUser) => blockedUser.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 390.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: ColorSchemes.white),
          child: Column(
            children: [
              Container(
                height: 72.h,
                padding: EdgeInsets.fromLTRB(0, 10.h, 0, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 28.r,
                          height: 28.r,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: SvgPicture.asset(
                              IconPath.close,
                              width: 14.r,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      '참여자 정보를 확인해 주세요',
                      style: Theme.of(context)
                          .textTheme
                          .bigHeadLine3
                          .copyWith(color: ColorSchemes.gray500, height: 1.193),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(top: 24.h),
                  itemCount: sortedUsers.length,
                  separatorBuilder: (context, index) => SizedBox(height: 18.h),
                  itemBuilder: (context, index) {
                    final user = sortedUsers[index];
                    final bool isPending =
                        sortedUsers[index].status == 'PENDING' ? true : false;
                    final bool isBlocked =
                        blockedUsersIds.contains(sortedUsers[index].id);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        if (user.userId == widget.hostUserId) {
                          return;
                        }
                        Navigator.pop(context);
                        final userCheckData =
                            await userService.getUserCheck(user.id);
                        if (userCheckData.status != 'BLOCKED') {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ProfileBottomSheet(
                                  userCheckData: userCheckData,
                                  selectedUserId: user.id,
                                  friendService: widget.friendService);
                            },
                          );
                        }
                      },
                      child: Participantlistprofile.icon(
                        profileImage: sortedUsers[index].profileUrl,
                        userName: sortedUsers[index].name,
                        userId: sortedUsers[index].userId,
                        users: sortedUsers,
                        isPending: isPending,
                        isBlocked: isBlocked,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
