import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/participate_bottom_sheet.dart';

import '../constants/assets_path.dart';
import '../constants/style_constants.dart';
import '../themes/color_schemes.dart';

class DetailScreenBottomSheet extends StatelessWidget {
  final bool isHost;
  final String title;
  final String meetingId;

  const DetailScreenBottomSheet(
      {super.key,
      required this.isHost,
      required this.title,
      this.meetingId = ''});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(StyleConstants.radiusLarge),
              topRight: Radius.circular(StyleConstants.radiusLarge),
            ),
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 38.h),
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bigHeadLine3
                          .copyWith(color: ColorSchemes.gray500),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                isHost
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ParticipateBottomSheet(
                                  isDeleteAllowed: true,
                                  meetingId: meetingId,
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '모닥불 삭제하기',
                              style: Theme.of(context)
                                  .textTheme
                                  .smallHeadLine3
                                  .copyWith(color: ColorSchemes.gray300),
                            ),
                            SizedBox(
                                height: 24.r,
                                width: 24.r,
                                child: SvgPicture.asset(
                                  IconPath.arrowForwardGray200,
                                  width: 20.r,
                                  fit: BoxFit.scaleDown,
                                )),
                          ],
                        ),
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '모닥불 신고하기',
                              style: Theme.of(context)
                                  .textTheme
                                  .smallHeadLine3
                                  .copyWith(color: ColorSchemes.gray300),
                            ),
                            SizedBox(
                                height: 24.r,
                                width: 24.r,
                                child: SvgPicture.asset(
                                  IconPath.arrowForwardGray200,
                                  width: 20.r,
                                  fit: BoxFit.scaleDown,
                                )),
                          ],
                        ),
                      ),
                SizedBox(height: 56.h),
              ],
            ),
          ),
        ));
  }
}
