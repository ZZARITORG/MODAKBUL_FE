import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/user_list_profile.dart';

class BlockedUserScreen extends StatelessWidget {
  BlockedUserScreen({super.key});

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
          child: /*Skeleton 들어갈 자리 */ SingleChildScrollView(
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
                    itemCount: blockedUsersData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: UserListProfile(
                            userName: blockedUsersData[index]['userName'],
                            userId: blockedUsersData[index]['userId']),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
