import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class BrowseTabScreen extends StatefulWidget {
  const BrowseTabScreen({super.key});

  @override
  State<BrowseTabScreen> createState() => _State();
}

class _State extends State<BrowseTabScreen> {
  final List<Map<String, dynamic>> myModakbulData = [
    {
      'profileLength': 3,
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'group': '서현애들',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
    },
    {
      'profileLength': 4,
      'title': '양지원 집 가서 옷 뺏을 사람?',
      'group': '디스코드',
      'date': '10.3(수) 오후 6시',
      'location': '양지원 집',
    },
    {
      'profileLength': 2,
      'title': '모각코 할 분?',
      'group': '코딩스터디',
      'date': '11.25(월) 오후 2시',
      'location': '코지카페',
    },
    {
      'profileLength': 2,
      'title': '모각코 할 분?',
      'group': '코딩스터디',
      'date': '11.25(월) 오후 2시',
      'location': '코지카페',
    },
    {
      'profileLength': 2,
      'title': '모각코 할 분?',
      'group': '코딩스터디',
      'date': '11.25(월) 오후 2시',
      'location': '코지카페',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium),
                color: ColorSchemes.white,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 10,
                      color: Color(0x40F3F3F3))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('혼자는 너무 춥지 않아?',
                        style: Theme.of(context)
                            .textTheme
                            .bigHeadLine4
                            .copyWith(color: ColorSchemes.orange200)),
                    SizedBox(
                      height: 6.h,
                    ),
                    Row(
                      children: [
                        Text('모닥불 피우러가기',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.orange100)),
                        SizedBox(
                          width: 6.w,
                        ),
                        SvgPicture.asset(IconPath.arrowForward15Orange100),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 75.w,
                  height: 75.h,
                )
              ],
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 7.h, horizontal: 14.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium),
                              color: ColorSchemes.orange200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('전체',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body3
                                      .copyWith(color: ColorSchemes.white))
                            ],
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
