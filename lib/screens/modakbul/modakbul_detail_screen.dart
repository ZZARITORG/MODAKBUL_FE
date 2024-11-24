import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/modakbul_detail_card.dart';

import '../../themes/color_schemes.dart';

class ModakbulDetailScreen extends StatefulWidget {
  const ModakbulDetailScreen({super.key});

  @override
  State<ModakbulDetailScreen> createState() => _ModakbulDetailScreenState();
}

class _ModakbulDetailScreenState extends State<ModakbulDetailScreen> {
  final String title = '편의점에서 간단하게 맥주 먹을 사람!';
  final String description =
      '해당 영역에 본문이 작성되고 최대 글자수에 따라 해상도 별로 줄이 길어지면 하단 위치 위젯과 동일한 마진으로 개발합니다. 하단과의 마진은 32px입니다';
  final String time = '10.1(화) 오후 7시';
  final String location = '서울 중구 마른대로 79';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  const ModakbulDetailCard(
                      userName: 'userName',
                      userId: 'userId',
                      posterProfileImage: 'posterProfileImage',
                      profileLength: 4,
                      participantProfileImage: 'participantProfileImage'),
                  SizedBox(
                    height: 14.h,
                  ),
                  SizedBox(
                    height: 146.h,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: SvgPicture.asset(
                                  IconPath.timeOrange200,
                                  width: 20.r,
                                  height: 20.r,
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                time,
                                style: Theme.of(context).textTheme.body2.copyWith(
                                    color: ColorSchemes.orange200, height: 1.5),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bigHeadLine3
                                      .copyWith(
                                          color: ColorSchemes.gray500,
                                          height: 1.193),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body3
                                      .copyWith(
                                          color: ColorSchemes.gray400,
                                          height: 1.625),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '위치',
                              style: Theme.of(context)
                                  .textTheme
                                  .bigHeadLine4
                                  .copyWith(
                                      color: ColorSchemes.gray400, height: 1.193),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    '상세 보기',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                            color: ColorSchemes.gray200,
                                            height: 1.5),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  SvgPicture.asset(
                                    IconPath.arrowForward15Gray200,
                                    width: 8.r,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 118.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40F3F3F3),
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ],
                              color: ColorSchemes.gray300),
                          child: Center(child: Text('지도 영역')),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            location,
                            style: Theme.of(context).textTheme.body3.copyWith(
                                color: ColorSchemes.gray300, height: 1.571),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  IconPath.copy,
                                  width: 15.r,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  '복사',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body3
                                      .copyWith(
                                          color: ColorSchemes.orange100,
                                          height: 1.571),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 22.h,
                left: 16.w,
                right: 16.w,
                child: SizedBox(
                  height: 56.h,
                  width: double.infinity,
                  child: CustomButton(
                      text: '모닥불 참여하기',
                      onPressed: () {},
                      buttonColor: ColorSchemes.orange200,
                      textStyle: Theme.of(context).textTheme.smallHeadLine2,
                      textColor: ColorSchemes.white),
                ))
          ],
        ),
      ),
    );
  }
}
