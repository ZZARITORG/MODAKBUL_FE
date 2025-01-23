import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/fixed_modakbul_card.dart';
import 'package:modakbul/widgets/default_tab_screen_skeleton.dart';
import 'package:modakbul/widgets/global_error_widget.dart';
import 'package:modakbul/widgets/my_modakbul_card.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:modakbul/models/my_host_modakbul.dart';

class DefaultTabScreen extends StatefulWidget {
  const DefaultTabScreen({super.key});

  @override
  State<DefaultTabScreen> createState() => _State();
}

class _State extends State<DefaultTabScreen> {
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final MeetingService meetingService = MeetingService();
  static const double _maxDragOffset = 36;
  bool isLoading = true;

  String _getLoadingAsset(double offset) {
    int segment = ((offset / _maxDragOffset) * 8).floor() + 1;
    segment = segment.clamp(1, 8);

    switch (segment) {
      case 1:
        return AnimationPath.loading1;
      case 2:
        return AnimationPath.loading2;
      case 3:
        return AnimationPath.loading3;
      case 4:
        return AnimationPath.loading4;
      case 5:
        return AnimationPath.loading5;
      case 6:
        return AnimationPath.loading6;
      case 7:
        return AnimationPath.loading7;
      case 8:
        return AnimationPath.loading8;
      default:
        return AnimationPath.loading1;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      meetingService.getMyHostModakbulList(),
      meetingService.getAcceptedModakbulList(),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
        onRefresh: _refreshData,
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {

          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              if (!controller.isIdle)
                Positioned(
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: Center(
                      child: controller.isLoading
                          ? Lottie.asset(
                        width: 25.r,
                        height: 25.r,
                        AnimationPath.loadingFeed,
                        animate: controller.isLoading,
                      )
                          : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return child;
                        },
                        child: SvgPicture.asset(
                          _getLoadingAsset(
                              controller.value * _maxDragOffset),
                          width: 25.r,
                          height: 25.r,
                          key: ValueKey<String>(_getLoadingAsset(
                              controller.value * _maxDragOffset)),
                        ),
                      ),
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(0, _maxDragOffset * controller.value),
                child: child,
              ),
            ],
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder<List>(
                  future: Future.wait([
                    meetingService.getMyHostModakbulList(),
                    meetingService.getAcceptedModakbulList(),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        isLoading == true) {
                      return DefaultTabScreenSkeleton();
                    } else if (snapshot.hasError) {
                      return SizedBox(
                        child: const GlobalErrorWidget(),
                      );
                    } else if (snapshot.hasData) {
                      isLoading = false;
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
                                  onTap: () => Routes.navigateTo(
                                      context, Routes.createModakbulScreen),
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w, 14.h, 16.w, 14.h),
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
                                    child: myHostModaktbulList.length > 0 &&
                                            isLoading == false
                                        ? Stack(
                                            children: [
                                              Positioned.fill(
                                                child: ClipRect(
                                                  child: PageView.builder(
                                                    controller: _pageController,
                                                    itemCount: myHostModaktbulList
                                                        .length,
                                                    onPageChanged: (index) {
                                                      setState(() {
                                                        _currentPage = index;
                                                      });
                                                    },
                                                    itemBuilder:
                                                        (context, index) {
                                                      String title =
                                                          myHostModaktbulList[
                                                                  index]!
                                                              .title;
                                                      String groupName =
                                                          myHostModaktbulList[
                                                                  index]!
                                                              .groupName;

                                                      String location =
                                                          myHostModaktbulList[
                                                                  index]!
                                                              .location;
                                                      DateTime utcDate =
                                                          myHostModaktbulList[
                                                                  index]!
                                                              .date;
                                                      Intl.defaultLocale =
                                                          'ko_KR';
                                                      String date = DateFormat(
                                                              'MM.dd(E) a h시 m분')
                                                          .format(utcDate);
                                                      String hostId =
                                                          myHostModaktbulList[
                                                                  index]!
                                                              .hostId;
                                                      List<UserStatus> users =
                                                          myHostModaktbulList[
                                                                  index]!
                                                              .users;
                                                      List<UserStatus>
                                                          participantUsers = users
                                                              .where((user) =>
                                                                  user.id !=
                                                                  hostId)
                                                              .toList();

                                                      return Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                16.w,
                                                                30.h,
                                                                16.w,
                                                                41.h),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              ColorSchemes.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            StyleConstants
                                                                .radiusMedium,
                                                          ),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              offset:
                                                                  Offset(0, 4),
                                                              blurRadius: 10,
                                                              color: Color(
                                                                  0x40F3F3F3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () => Routes
                                                                  .navigateTo(
                                                                      context,
                                                                      Routes
                                                                          .modakbulDetailScreen,
                                                                      arguments: {
                                                                    'id': myHostModaktbulList[
                                                                            index]
                                                                        .id,
                                                                        'isAccepted': true,
                                                                  }),
                                                              behavior:
                                                                  HitTestBehavior
                                                                      .opaque,
                                                              child:
                                                                  MyModakbulCard(
                                                                participantLength:
                                                                    users.length,
                                                                title: title,
                                                                groupName:
                                                                    groupName,
                                                                date: date,
                                                                location: location,
                                                                participantUsers:
                                                                    participantUsers,
                                                              ),
                                                            ),
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
                                                    myHostModaktbulList.length >=
                                                            5
                                                        ? 5
                                                        : myHostModaktbulList
                                                            .length,
                                                    (dotIndex) =>
                                                        AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w),
                                                      width: (_currentPage >= 5 &&
                                                                  dotIndex ==
                                                                      4) ||
                                                              (_currentPage ==
                                                                  dotIndex)
                                                          ? 18.w
                                                          : 6.w,
                                                      height: 6.h,
                                                      decoration: BoxDecoration(
                                                        color: (_currentPage >= 5 &&
                                                                    dotIndex ==
                                                                        4) ||
                                                                _currentPage ==
                                                                    dotIndex
                                                            ? ColorSchemes
                                                                .orange200
                                                            : ColorSchemes
                                                                .gray200,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          (_currentPage >= 5 &&
                                                                      dotIndex ==
                                                                          4) ||
                                                                  _currentPage ==
                                                                      dotIndex
                                                              ? 4.r
                                                              : 50.r,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            width: double.infinity,
                                            height: 238.h,
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
                                                SizedBox(
                                                  width: 115.w,
                                                  height: 115.h,
                                                  child: Image.asset(
                                                    ImagePath.offBonfire,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 24.h,
                                                ),
                                                Text('혼자는 너무 춥지 않아?',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bigHeadLine4
                                                        .copyWith(
                                                            color: ColorSchemes
                                                                .orange100)),
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Text('회원님이 피운 모닥불이 없습니다.',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .body1
                                                        .copyWith(
                                                            color: ColorSchemes
                                                                .gray200)),
                                              ],
                                            ),
                                          )),
                                SizedBox(
                                  height: 24.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('약속된 모닥불',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bigHeadLine4
                                            .copyWith(
                                                color: ColorSchemes.gray500)),
                                    TextButton(
                                      onPressed: () => Routes.navigateTo(
                                          context, Routes.myModakbulScreen),
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
                          acceptedModakbulList.length > 0
                              ? SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width - 32.w,
                                    child: Row(
                                      children: List.generate(
                                        acceptedModakbulList.length,
                                        (index) {
                                          String title =
                                              acceptedModakbulList[index]!.title;
                                          DateTime utcDate =
                                              acceptedModakbulList[index]!.date;
                                          DateTime kstDate =
                                              utcDate.add(Duration(hours: 9));
                                          Intl.defaultLocale = 'ko_KR';
                                          String date =
                                              DateFormat('MM.dd(E) a h시 m분')
                                                  .format(kstDate);
                                          String location =
                                              acceptedModakbulList[index]!.address;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: index ==
                                                      acceptedModakbulList.length -
                                                          1
                                                  ? 0
                                                  : 8.w,
                                            ),
                                            child: GestureDetector(
                                              onTap: () => Routes.navigateTo(
                                                  context,
                                                  Routes.modakbulDetailScreen,
                                                  arguments: {
                                                    'id':
                                                        acceptedModakbulList[index]
                                                            .id,
                                                    'isAccepted' : true
                                                  }),
                                              behavior: HitTestBehavior.opaque,
                                              child: FixedModakbulCard(
                                                title: title,
                                                date: date.toString(),
                                                location: location,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 40.h),
                                  child: Column(
                                    children: [
                                      Text('더이상 모닥불이 없습니다.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bigHeadLine3
                                              .copyWith(
                                                  color: ColorSchemes.orange100)),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text('모닥불을 참여해보세요',
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2
                                              .copyWith(
                                                  color: ColorSchemes.gray300)),
                                    ],
                                  ),
                                ),
                          SizedBox(height: 16.h),
                        ],
                      );
                    } else {
                      return Text('기모띠');
                    }
                  }),
            ],
          ),
        ),
      );
  }
}
