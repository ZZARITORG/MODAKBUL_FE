import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/fixed_modakbul_card.dart';
import 'package:modakbul/widgets/default_tab_screen_skeleton.dart';
import 'package:modakbul/widgets/my_modakbul_card.dart';

import '../../../models/my_host_modakbul.dart';

class DefaultTabScreen extends StatefulWidget {
  const DefaultTabScreen({super.key});

  @override
  State<DefaultTabScreen> createState() => _State();
}

class _State extends State<DefaultTabScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  final MeetingService meetingService = MeetingService();

  final List<Map<String, dynamic>> myModakbulData = [
    {
      'profileLength': 4,
      'title': '양지원 집 가서 옷 뺏을 사람?',
      'group': '디스코드',
      'date': '10.3(수) 오후 6시',
      'location': '양지원 집',
    },
    {
      'profileLength': 4,
      'title': '양지원 집 가서 옷 뺏을 사람?',
      'group': '디스코드',
      'date': '10.3(수) 오후 6시',
      'location': '양지원 집',
    },
    {
      'profileLength': 4,
      'title': '양지원 집 가서 옷 뺏을 사람?',
      'group': '디스코드',
      'date': '10.3(수) 오후 6시',
      'location': '양지원 집',
    },
    {
      'profileLength': 4,
      'title': '양지원 집 가서 옷 뺏을 사람?',
      'group': '디스코드',
      'date': '10.3(수) 오후 6시',
      'location': '양지원 집',
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
      'profileLength': 3,
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'group': '서현애들',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
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
    return SingleChildScrollView(
      child: Column(
        children: [
          /* 스켈레톤 조건문 들어갈 영역 */
          /* 1.로딩 2.error 3. null*/
          FutureBuilder<List>(
              future: Future.wait([
                meetingService.getMyHostModakbulList(),
                meetingService.getAcceptedModakbulList(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return DefaultTabScreenSkeleton();
                } else if (snapshot.hasError) {
                  return Text('에러');
                } else if (snapshot.hasData) {
                  final myHostModaktbulList = snapshot.data![0];
                  final acceptedModakbulList = snapshot.data![1];

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14.h),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        StyleConstants.radiusMedium),
                                    color: ColorSchemes.white,
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 10,
                                          color: Color(0x40F3F3F3))
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('혼자는 너무 춥지 않아?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bigHeadLine4
                                                .copyWith(
                                                    color: ColorSchemes
                                                        .orange200)),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Row(
                                          children: [
                                            Text('모닥불 피우러가기',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body2
                                                    .copyWith(
                                                        color: ColorSchemes
                                                            .orange100)),
                                            SizedBox(
                                              width: 6.w,
                                            ),
                                            SvgPicture.asset(IconPath
                                                .arrowForward15Orange100),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 75.r,
                                      height: 75.r,
                                      child:
                                          Image.asset(ImagePath.homeModakbul),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            SizedBox(
                              height: 114.h + 92.25.sp + 34.r,
                              child: myHostModaktbulList.length > 0 ? Stack(
                                children: [
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
                                          String title =
                                              myHostModaktbulList[index]!.title;
                                          String content =
                                              myHostModaktbulList[index]!
                                                  .content;
                                          String location =
                                              myHostModaktbulList[index]!
                                                  .location;
                                          String address =
                                              myHostModaktbulList[index]!
                                                  .address;
                                          String detailAddress =
                                              myHostModaktbulList[index]!
                                                  .detailAddress;
                                          DateTime date =
                                              myHostModaktbulList[index]!.date;
                                          List<UserStatus> users =
                                              myHostModaktbulList[index]!.users;

                                          return Container(
                                            padding: EdgeInsets.fromLTRB(
                                                16.w, 30.h, 16.w, 41.h),
                                            decoration: BoxDecoration(
                                              color: ColorSchemes.white,
                                              borderRadius:
                                              BorderRadius.circular(
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
                                                    profileLength: users.length,
                                                    title: title,
                                                    group: data['group'],
                                                    date: date.toString(),
                                                    location: address),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: List.generate(
                                        myModakbulData.length >= 5
                                            ? 5
                                            : myModakbulData.length,
                                            (dotIndex) => AnimatedContainer(
                                          duration:
                                          const Duration(milliseconds: 300),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2.w),
                                          width: (_currentPage >= 5 &&
                                              dotIndex == 4) ||
                                              (_currentPage == dotIndex)
                                              ? 18.w
                                              : 6.w,
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            color: (_currentPage >= 5 &&
                                                dotIndex == 4) ||
                                                _currentPage == dotIndex
                                                ? ColorSchemes.orange200
                                                : ColorSchemes.gray200,
                                            borderRadius: BorderRadius.circular(
                                              (_currentPage >= 5 &&
                                                  dotIndex == 4) ||
                                                  _currentPage == dotIndex
                                                  ? 4.r
                                                  : 50.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ) : Text('데이터가 없습니다')
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
                                  onPressed: () => Routes.navigateTo(context, Routes.myModakbulScreen),
                                  child: Text('전체보기',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body3
                                          .copyWith(
                                              color: ColorSchemes.gray300)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                          ],
                        ),
                      ),
                      acceptedModakbulList.length > 0 ? SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            scheduledModakbulData.length,
                                (index) {
                              final data = scheduledModakbulData[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right:
                                  index == scheduledModakbulData.length - 1
                                      ? 0
                                      : 8.w,
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
                      ) : Text('데이터가 없습니다.'),
                      SizedBox(height: 16.h),
                    ],
                  );
                } else {
                  return Text('기모띠');
                }
              }),
        ],
      ),
    );
  }
}
