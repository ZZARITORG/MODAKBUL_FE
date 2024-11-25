import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/fixed_modakbul_card.dart';
import 'package:modakbul/widgets/my_modakbul_card.dart';

class DefaultTabScreen extends StatefulWidget {
  const DefaultTabScreen({super.key});

  @override
  State<DefaultTabScreen> createState() => _State();
}

class _State extends State<DefaultTabScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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

  final List<Map<String, dynamic>> scheduledModakbulData = [
    {
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
    },
    {
      'title': '양지원 집 가서 옷 뺏을 사람?',
      'date': '10.3(수) 오후 6시',
      'location': '양지원 집',
    },
    {
      'title': '모각코 할 분?',
      'date': '11.25(월) 오후 2시',
      'location': '코지카페',
    },
    {
      'title': '모각코 할 분?',
      'date': '11.25(월) 오후 2시',
      'location': '코지카페',
    },
    {
      'title': '모각코 할 분?',
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
            height: 14.h,
          ),
          Container(
            height: 238.h,
            child: Stack(
              children: [
                // PageView 내부
                Positioned.fill(
                  child: ClipRect(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: myModakbulData.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final data = myModakbulData[index];
                        return Container(
                          padding: EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 16.h),
                          decoration: BoxDecoration(
                            color: ColorSchemes.white,
                            borderRadius: BorderRadius.circular(
                              StyleConstants.radiusMedium,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                color: Color(0x40F3F3F3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              MyModakbulCard(
                                  profileLength: data['profileLength'],
                                  title: data['title'],
                                  group: data['group'],
                                  date: data['date'],
                                  location: data['location']),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      myModakbulData.length,
                      (dotIndex) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        width: _currentPage == dotIndex ? 18.w : 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _currentPage == dotIndex
                              ? ColorSchemes.orange200
                              : ColorSchemes.gray200,
                          borderRadius: BorderRadius.circular(
                            _currentPage == dotIndex && _currentPage != dotIndex
                                ? 4.r
                                : 50.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('약속된 모닥불',
                  style: Theme.of(context)
                      .textTheme
                      .bigHeadLine4
                      .copyWith(color: ColorSchemes.gray500)),
              TextButton(
                onPressed: (){},
                child: Text('전체보기',
                    style: Theme.of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.gray300)),
              ),
            ],
          ),
          SizedBox(
            height: 14.h,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                scheduledModakbulData.length,
                    (index) {
                  final data = scheduledModakbulData[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == scheduledModakbulData.length - 1 ? 0 : 8.w, // 마지막 카드에는 오른쪽 간격 없앰
                    ),
                    child: FixedModakbulCard(
                      title: data['title'],
                      date: data['date'],
                      location: data['location'],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
