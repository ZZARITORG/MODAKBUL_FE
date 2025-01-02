import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

import '../models/accept_modakbul.dart';
import '../routes/routes.dart';
import '../services/meeting_service.dart';

class ParticipateBottomSheet extends StatelessWidget {
  final String meetingId;
  final bool isAccepted;
  final bool isDeleteAllowed;

  const ParticipateBottomSheet({
    super.key,
    this.meetingId = '',
    this.isAccepted = false,
    this.isDeleteAllowed = false,
  });

  @override
  Widget build(BuildContext context) {
    MeetingService meetingService = MeetingService();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 241.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(StyleConstants.radiusLarge),
                topRight: Radius.circular(StyleConstants.radiusLarge),
              ),
              color: ColorSchemes.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 38.h,
              ),
              Text(
                isDeleteAllowed
                    ? '모닥불 삭제'
                    : isAccepted
                        ? '모닥불 취소'
                        : '모닥불 참여',
                style: Theme.of(context).textTheme.bigHeadLine3.copyWith(
                    color: ColorSchemes.gray500,
                    height: 1.193,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 12.h,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  isDeleteAllowed
                      ? '정말로 모닥불을 삭제하시겠습니까?'
                      : isAccepted
                          ? '정말로 모닥불을 취소하시겠습니까?'
                          : '정말로 모닥불에 참여하시겠습니까?',
                  style: Theme.of(context).textTheme.body2.copyWith(
                      color: ColorSchemes.gray400,
                      height: 1.5,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 57.h,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: isDeleteAllowed
                      ? CustomButton(
                          text: '모닥불 삭제',
                          onPressed: () async {
                            await meetingService.deleteModakbul(meetingId);
                            Routes.navigateAndRemoveUntil(
                                context, Routes.mainScreen);
                          },
                          buttonColor: ColorSchemes.orange200,
                          textStyle: Theme.of(context).textTheme.smallHeadLine2,
                          textColor: ColorSchemes.white)
                      : isAccepted
                          ? CustomButton(
                              text: '모닥불 취소',
                              onPressed: () async {
                                await meetingService.cancelModakbul(meetingId);
                                Routes.navigateAndRemoveUntil(
                                    context, Routes.mainScreen);
                              },
                              buttonColor: ColorSchemes.orange200,
                              textStyle:
                                  Theme.of(context).textTheme.smallHeadLine2,
                              textColor: ColorSchemes.white)
                          : CustomButton(
                              text: '모닥불 참여',
                              onPressed: () async {
                                final acceptModakbul =
                                    AcceptModakbul(meetingId: meetingId);
                                await meetingService
                                    .acceptModakbul(acceptModakbul);
                                Routes.navigateAndRemoveUntil(
                                    context, Routes.mainScreen);
                              },
                              buttonColor: ColorSchemes.orange200,
                              textStyle:
                                  Theme.of(context).textTheme.smallHeadLine2,
                              textColor: ColorSchemes.white))
            ],
          ),
        ),
      ),
    );
  }
}
