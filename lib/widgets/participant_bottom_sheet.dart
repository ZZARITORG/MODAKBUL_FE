import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/participant_list_profile.dart';

import '../constants/assets_path.dart';
import '../themes/color_schemes.dart';

class ParticipantBottomSheet extends StatefulWidget {
  const ParticipantBottomSheet({Key? key}) : super(key: key);

  @override
  State<ParticipantBottomSheet> createState() => _ParticipantBottomSheetState();
}

class _ParticipantBottomSheetState extends State<ParticipantBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          height: 390.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: ColorSchemes.white
          ),
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
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            IconPath.close,
                            width: 14.r,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    '참여자 정보를 확인하세요.',
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
                itemCount: 4, // 예시로 10명
                separatorBuilder: (context, index) => SizedBox(height: 18.h),
                itemBuilder: (context, index) {
                  return Participantlistprofile(
                    userName: 'userName $index',
                    userId: 'userId $index',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
