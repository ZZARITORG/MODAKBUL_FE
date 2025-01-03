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

class BlockedUserScreen extends StatelessWidget {
  BlockedUserScreen({super.key});

  FriendService friendService = FriendService();

  final List<Map<String, dynamic>> blockedUsersData = [
    {
      'userName': 'Alice Kim',
      'userId': 'alice_kim',
      'profileImage': 'https://via.placeholder.com/150?text=Alice'
    },
    {
      'userName': 'Bob Lee',
      'userId': 'bob_lee',
      'profileImage': 'https://via.placeholder.com/150?text=Bob'
    },
    {
      'userName': 'Charlie Park',
      'userId': 'charlie_park',
      'profileImage': 'https://via.placeholder.com/150?text=Charlie'
    },
    {
      'userName': 'Diana Choi',
      'userId': 'diana_choi',
      'profileImage': 'https://via.placeholder.com/150?text=Diana'
    },
    {
      'userName': 'Ethan Song',
      'userId': 'ethan_song',
      'profileImage': 'https://via.placeholder.com/150?text=Ethan'
    },
    {
      'userName': 'Fiona Lee',
      'userId': 'fiona_lee',
      'profileImage': 'https://via.placeholder.com/150?text=Fiona'
    },
    {
      'userName': 'George Kim',
      'userId': 'george_kim',
      'profileImage': 'https://via.placeholder.com/150?text=George'
    },
    {
      'userName': 'Hannah Jung',
      'userId': 'hannah_jung',
      'profileImage': 'https://via.placeholder.com/150?text=Hannah'
    },
    {
      'userName': 'Ian Kang',
      'userId': 'ian_kang',
      'profileImage': 'https://via.placeholder.com/150?text=Ian'
    },
    {
      'userName': 'Julia Park',
      'userId': 'julia_park',
      'profileImage': 'https://via.placeholder.com/150?text=Julia'
    },
    {
      'userName': 'Kevin Lee',
      'userId': 'kevin_lee',
      'profileImage': 'https://via.placeholder.com/150?text=Kevin'
    },
    {
      'userName': 'Laura Kim',
      'userId': 'laura_kim',
      'profileImage': 'https://via.placeholder.com/150?text=Laura'
    },
    {
      'userName': 'Michael Song',
      'userId': 'michael_song',
      'profileImage': 'https://via.placeholder.com/150?text=Michael'
    },
    {
      'userName': 'Nina Choi',
      'userId': 'nina_choi',
      'profileImage': 'https://via.placeholder.com/150?text=Nina'
    },
    {
      'userName': 'Oliver Park',
      'userId': 'oliver_park',
      'profileImage': 'https://via.placeholder.com/150?text=Oliver'
    },
    {
      'userName': 'Paula Kang',
      'userId': 'paula_kang',
      'profileImage': 'https://via.placeholder.com/150?text=Paula'
    },
    {
      'userName': 'Quincy Kim',
      'userId': 'quincy_kim',
      'profileImage': 'https://via.placeholder.com/150?text=Quincy'
    },
    {
      'userName': 'Rachel Lee',
      'userId': 'rachel_lee',
      'profileImage': 'https://via.placeholder.com/150?text=Rachel'
    },
    {
      'userName': 'Steve Choi',
      'userId': 'steve_choi',
      'profileImage': 'https://via.placeholder.com/150?text=Steve'
    },
    {
      'userName': 'Tina Jung',
      'userId': 'tina_jung',
      'profileImage': 'https://via.placeholder.com/150?text=Tina'
    },
  ];

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
                              SizedBox(height: 80.h),
                              Text(
                                '차단된 친구가 없습니다.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine3
                                    .copyWith(color: ColorSchemes.orange100),
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
                                      id: blockedUserList[index].id));
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
