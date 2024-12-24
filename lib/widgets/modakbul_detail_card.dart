import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/models/modakbul_detail.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/participant_bottom_sheet.dart';
import '../constants/assets_path.dart';
import '../constants/style_constants.dart';

class ModakbulDetailCard extends StatelessWidget {
  final String hostName;
  final String hostId;
  final int participantLength;
  final String hostProfileImage;
  final List<UserStatus> users;
  final List<UserStatus> participantUsers;

  const ModakbulDetailCard({
    super.key,
    required this.hostName,
    required this.hostId,
    required this.hostProfileImage,
    required this.participantLength,
    required this.users,
    required this.participantUsers,
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
                      hostId,
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
          GestureDetector(
            onTap: () {
              if (participantLength > 1) {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext bottomSheetContext) {
                      return ParticipantBottomSheet(users: users, hostId: hostId);
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
                                        backgroundImage: NetworkImage(participantUsers[0].profileUrl),
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
                                        backgroundImage: NetworkImage(participantUsers[1].profileUrl),
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
