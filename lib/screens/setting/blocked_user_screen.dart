import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/blocked_user_screen_skeleton.dart';
import 'package:modakbul/widgets/user_list_profile.dart';
import 'package:modakbul/models/blocked_user.dart';

class BlockedUserScreen extends StatefulWidget {
  BlockedUserScreen({super.key});

  @override
  State<BlockedUserScreen> createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen> {
  FriendService friendService = FriendService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
          child: FutureBuilder<List<BlockedUser>>(
              future: friendService.getBlockedUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BlockedUserScreenSkeleton();
                } else if (snapshot.hasError) {
                  return Text('오류 발생: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('데이터가 없습니다.');
                } else if (snapshot.data!.isEmpty) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 26.h),
                        Text('차단된 사용자',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.orange200)),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: 202.h),
                              Text(
                                '차단된 친구가 없어요',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine3
                                    .copyWith(color: ColorSchemes.orange100),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '친구를 추가하고 모닥불을 피워보세요.',
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(color: ColorSchemes.gray300),
                              ),
                            ],
                          ),
                        ),
                      ]);
                } else {
                  List<BlockedUser> blockedUserList = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 26.h),
                        Text('차단된 사용자',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.orange200)),
                        SizedBox(height: 24.h),
                        ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: blockedUserList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: UserListProfile.icon(
                                      userName: blockedUserList[index].name,
                                      userId: blockedUserList[index].userId,
                                      profileImage:
                                          blockedUserList[index].profileUrl,
                                      id: blockedUserList[index].id,
                                    onUnblockSuccess: () {
                                      setState(() {
                                        blockedUserList.removeAt(index);
                                      });
                                    },
                                  ));
                            })
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
