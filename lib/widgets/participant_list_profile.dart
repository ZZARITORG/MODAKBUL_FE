import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/modakbul_detail.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/themes/color_schemes.dart';

class Participantlistprofile extends StatelessWidget {
  final String profileImage;
  final String userName;
  final String userId;
  final List<UserStatus> users;

  const Participantlistprofile({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.userId,
    this.users = const [],
  }) : super(key: key);

  factory Participantlistprofile.icon(
          {required String profileImage,
          required String userName,
          required userId,
          required List<UserStatus> users}) =>
      Participantlistprofile(
          profileImage: profileImage, userName: userName, userId: userId, users: users,);

  Widget _buildUserStatus() {
    if (users.isNotEmpty) {
      if (users[0].userId == userId) { //호스트
        return SizedBox(width: 24.w, height: 24.h,
          child: Image.asset(ImagePath.hostBonfire, fit: BoxFit.contain,),
        );
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: StyleConstants.circleSizeS,
                  backgroundImage: NetworkImage(profileImage),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .smallHeadLine3
                            .copyWith(color: ColorSchemes.gray500),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userId,
                          style: Theme.of(context)
                              .textTheme
                              .body3
                              .copyWith(color: ColorSchemes.gray300),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildUserStatus()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
