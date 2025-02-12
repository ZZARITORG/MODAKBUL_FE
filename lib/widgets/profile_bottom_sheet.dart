import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class ProfileBottomSheet extends StatelessWidget {
  final UserCheck userCheckData;
  final String selectedUserId;
  final FriendService friendService;

  const ProfileBottomSheet({
    Key? key,
    required this.userCheckData,
    required this.selectedUserId,
    required this.friendService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(StyleConstants.radiusLarge),
          topRight: Radius.circular(StyleConstants.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    IconPath.moreHorizontal,
                    width: 20.w,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    IconPath.arrowDown,
                    width: 18.w,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 26.h),
          Padding(
            padding: EdgeInsets.only(left: 20.h, right: 24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userCheckData.mutualCount == 0)
                        SizedBox(height: 14.h),
                      Text(
                        userCheckData.name,
                        style: Theme.of(context)
                            .textTheme
                            .bigHeadLine2
                            .copyWith(color: ColorSchemes.gray500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        userCheckData.userId,
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: ColorSchemes.gray300),
                      ),
                      SizedBox(height: 6.h),
                      if (userCheckData.mutualCount > 0)
                        Text(
                          '함께하는 친구가 ${userCheckData.mutualCount}명 있습니다!',
                          style: Theme.of(context)
                              .textTheme
                              .body3
                              .copyWith(color: ColorSchemes.gray200),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 37.w),
                CircleAvatar(
                  radius: StyleConstants.circleSizeL,
                  backgroundImage: NetworkImage(userCheckData.profileUrl),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: SizedBox(
              width: double.infinity,
              child: userCheckData.status == 'PENDING'
                  ? userCheckData.sourceId == selectedUserId
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: CustomButton(
                                  text: '친구 수락',
                                  onPressed: () {
                                    friendService
                                        .acceptFriend(
                                            Uuid(targetId: selectedUserId))
                                        .then((_) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  buttonColor: ColorSchemes.orange200,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .smallHeadLine2,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: CustomButton(
                                  text: '삭제',
                                  onPressed: () {
                                    friendService
                                        .deleteFriend(
                                            Uuid(targetId: selectedUserId))
                                        .then((_) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  buttonColor: ColorSchemes.gray100,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .smallHeadLine2,
                                  textColor: ColorSchemes.gray400,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 56.h,
                          child: CustomButton(
                            text: '요청 취소',
                            onPressed: () {
                              friendService
                                  .deleteFriend(Uuid(targetId: selectedUserId))
                                  .then((_) {
                                Navigator.pop(context);
                              });
                            },
                            buttonColor: ColorSchemes.orange100,
                            textStyle:
                                Theme.of(context).textTheme.smallHeadLine2,
                            textColor: Colors.white,
                          ),
                        )
                  : SizedBox(
                      height: 56.h,
                      child: CustomButton(
                        text: userCheckData.status == 'ACCEPTED'
                            ? '친구 삭제'
                            : userCheckData.status == 'PENDING'
                                ? (userCheckData.sourceId == selectedUserId
                                    ? '친구 수락'
                                    : '삭제')
                                : '친구 요청',
                        onPressed: () {
                          print('유저스테이터스${userCheckData.status}');
                          switch (userCheckData.status) {
                            case 'ACCEPTED':
                              friendService
                                  .deleteFriend(Uuid(targetId: selectedUserId))
                                  .then((_) {
                                Navigator.pop(context);
                              });
                              break;
                            case 'REJECTED':
                              friendService
                                  .requestFriend(Uuid(targetId: selectedUserId))
                                  .then((_) {
                                Navigator.pop(context);
                              });
                              break;
                            case 'NONE':
                              friendService
                                  .requestFriend(
                                      Uuid(targetId: selectedUserId))
                                  .then((_) {
                                Navigator.pop(context);
                              });
                          }
                        },
                        buttonColor: ColorSchemes.orange200,
                        textStyle: Theme.of(context).textTheme.smallHeadLine2,
                        textColor: Colors.white,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 56.h),
        ],
      ),
    );
  }
}
