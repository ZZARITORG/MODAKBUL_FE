import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final bool isPending;
  final bool isBlocked;

  const Participantlistprofile({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.userId,
    this.isPending = false,
    this.isBlocked = false,
    this.users = const [],
  }) : super(key: key);

  factory Participantlistprofile.icon(
          {required String profileImage,
          required String userName,
          required userId,
          required isPending,
          required isBlocked,
          required List<UserStatus> users}) =>
      Participantlistprofile(
        profileImage: profileImage,
        userName: userName,
        userId: userId,
        users: users,
        isPending: isPending,
        isBlocked: isBlocked,
      );

  Widget _buildUserStatus() {
    if (users.isNotEmpty) {
      if (users[0].userId == userId) {
        //호스트
        return SizedBox(
          width: 24.w,
          height: 24.h,
          child: Image.asset(
            ImagePath.hostBonfire,
            fit: BoxFit.contain,
          ),
        );
      } else if (isBlocked) {
        return SizedBox(
          width: 24.r,
          height: 24.r,
          child: Center(
            child: SvgPicture.asset(
              IconPath.warningRed,
              width: 18.r,
              height: 18.r,
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final isHost = users.isNotEmpty && users[0].userId == userId;
    final userNameColor = isHost
        ? ColorSchemes.gray500
        : (isPending ? ColorSchemes.gray300 : ColorSchemes.gray500);

    final userIdColor = isHost
        ? ColorSchemes.gray300
        : (isPending ? ColorSchemes.gray200 : ColorSchemes.gray300);


    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                isBlocked
                    ? CircleAvatar(
                        radius: StyleConstants.circleSizeS,
                        child: ClipOval(
                            child: CachedNetworkImage(
                                imageUrl:
                                    'https://s3.ap-northeast-2.amazonaws.com/zzarit-madakbul-bucket/profile/default')),
                      )
                    : CircleAvatar(
                        radius: StyleConstants.circleSizeS,
                        child: ClipOval(
                            child: CachedNetworkImage(imageUrl: profileImage)),
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
                            .copyWith(color: isBlocked ? ColorSchemes.red : userNameColor),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isBlocked ? '차단된 사용자 입니다.' : userId,
                          style: Theme.of(context)
                              .textTheme
                              .body3
                              .copyWith(color: isBlocked ? ColorSchemes.gray200 : userIdColor),
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
