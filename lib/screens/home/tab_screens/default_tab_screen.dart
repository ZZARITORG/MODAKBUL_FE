import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:modakbul/screens/main_screen.dart';
import '../../../services/friend_service.dart';
import 'package:modakbul/models/my_host_modakbul.dart' as host_model;
import 'package:modakbul/models/accepted_modakbul.dart' as accepted_model;

class DefaultTabScreen extends StatefulWidget {
  const DefaultTabScreen({super.key});

  @override
  State<DefaultTabScreen> createState() => _State();
}

class _State extends State<DefaultTabScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final MeetingService meetingService = MeetingService();
  final FriendService friendService = FriendService();

  static const double _maxDragOffset = 36;
  bool isLoading = false;
  bool _wasRefreshing = false;

  bool isFirstLoading = true;
  late Future<List<dynamic>> _dataFuture = Future.value([]);

  String _getLoadingAsset(double offset) {
    int segment = ((offset / _maxDragOffset) * 8).floor() + 1;
    segment = segment.clamp(1, 8);
    switch (segment) {
      case 1: return AnimationPath.loading1;
      case 2: return AnimationPath.loading2;
      case 3: return AnimationPath.loading3;
      case 4: return AnimationPath.loading4;
      case 5: return AnimationPath.loading5;
      case 6: return AnimationPath.loading6;
      case 7: return AnimationPath.loading7;
      case 8: return AnimationPath.loading8;
      default: return AnimationPath.loading1;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _dataFuture = Future.wait([
      meetingService.getMyHostModakbulList(),
      meetingService.getAcceptedModakbulList(),
    ]).whenComplete(() {
      setState(() => isFirstLoading = false);
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      _dataFuture = Future.wait([
        meetingService.getMyHostModakbulList(),
        meetingService.getAcceptedModakbulList(),
      ]);
    });
    await _dataFuture;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomRefreshIndicator(
      offsetToArmed: _maxDragOffset,
      onRefresh: _refreshData,
      builder: (context, child, controller) {
        if (controller.isLoading && !_wasRefreshing) {
          HapticFeedback.lightImpact();
          _wasRefreshing = true;
        } else if (!controller.isLoading && _wasRefreshing) {
          _wasRefreshing = false;
        }
        return Stack(
          alignment: Alignment.topCenter,
          children: [
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
                      transitionBuilder: (c, a) => c,
                      child: SvgPicture.asset(
                        _getLoadingAsset(controller.value * _maxDragOffset),
                        width: 25.r,
                        height: 25.r,
                        key: ValueKey(
                            _getLoadingAsset(controller.value * _maxDragOffset)),
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
        child: FutureBuilder<List<dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final hasFullData = data != null && data.length >= 2;
            if (snapshot.connectionState == ConnectionState.waiting &&
                isFirstLoading) {
              return DefaultTabScreenSkeleton();
            } else if (snapshot.hasError) {
              return GlobalErrorWidget();
            } else if (hasFullData) {
              final myHostList =
              data![0] as List<host_model.MyHostModakbul>;
              final acceptedList =
              data[1] as List<accepted_model.AcceptedModakbul>;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 14.h),
                        GestureDetector(
                          onTap: () {
                            if (mounted) {
                              context
                                  .findAncestorStateOfType<
                                  MainScreenState>()!
                                  .setState(() => context
                                  .findAncestorStateOfType<
                                  MainScreenState>()!
                                  .selectedIndex = 2);
                            }
                          },
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
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '혼자는 너무 춥지 않아?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bigHeadLine4!
                                          .copyWith(
                                          color:
                                          ColorSchemes.orange200),
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Text(
                                          '모닥불 피우러가기',
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2!
                                              .copyWith(
                                              color: ColorSchemes
                                                  .orange100),
                                        ),
                                        SizedBox(width: 6.w),
                                        SvgPicture.asset(
                                            IconPath
                                                .arrowForward15Orange100),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 75.w,
                                  height: 75.h,
                                  child:
                                  Image.asset(ImagePath.homeModakbul),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        SizedBox(
                          height: 124.h + 92.25.sp + 32.r,
                          child: myHostList.isNotEmpty
                              ? Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRect(
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: myHostList.length,
                                    onPageChanged: (i) =>
                                        setState(() => _currentPage = i),
                                    itemBuilder: (ctx, i) {
                                      final item = myHostList[i];
                                      String date = DateFormat(
                                          'MM.dd(E) a h시 m분',
                                          'ko_KR')
                                          .format(item.date);
                                      List<host_model.UserStatus>
                                      participants = item.users
                                          .where((u) =>
                                      u.id !=
                                          item.hostId)
                                          .toList();
                                      return Container(
                                        padding: EdgeInsets.fromLTRB(
                                            16.w, 30.h, 16.w, 41.h),
                                        decoration: BoxDecoration(
                                          color: ColorSchemes.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                            StyleConstants
                                                .radiusMedium,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 10,
                                              color: Color(
                                                  0x40F3F3F3),
                                            ),
                                          ],
                                        ),
                                        child: GestureDetector(
                                          onTap: () =>
                                              Routes.navigateTo(
                                                context,
                                                Routes
                                                    .modakbulDetailScreen,
                                                arguments: {
                                                  'id': item.id,
                                                  'isAccepted': true
                                                },
                                              ),
                                          behavior:
                                          HitTestBehavior.opaque,
                                          child: MyModakbulCard(
                                            participantLength:
                                            item.users.length,
                                            title: item.title,
                                            groupName:
                                            item.groupName,
                                            date: date,
                                            location:
                                            item.location,
                                            participantUsers:
                                            participants,
                                            users: item.users,
                                            isBlocked: false,
                                            isPending: false,
                                            userId: item.hostId,
                                            friendService:
                                            friendService,
                                          ),
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
                                    myHostList.length >= 5
                                        ? 5
                                        : myHostList.length,
                                        (dot) => AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 300),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2.w),
                                      width: (_currentPage >= 5 &&
                                          dot == 4) ||
                                          _currentPage == dot
                                          ? 18.w
                                          : 6.w,
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                        color: (_currentPage >= 5 &&
                                            dot == 4) ||
                                            _currentPage == dot
                                            ? ColorSchemes.orange200
                                            : ColorSchemes.gray200,
                                        borderRadius:
                                        BorderRadius.circular(
                                          ((_currentPage >= 5 &&
                                              dot == 4) ||
                                              _currentPage == dot)
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
                              borderRadius:
                              BorderRadius.circular(StyleConstants.radiusMedium),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 10,
                                    color: Color(0x40F3F3F3))
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
                                SizedBox(height: 24.h),
                                Text(
                                  '혼자는 너무 춥지 않아?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bigHeadLine4!
                                      .copyWith(color: ColorSchemes.orange100),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '회원님이 피운 모닥불이 없습니다.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1!
                                      .copyWith(color: ColorSchemes.gray200),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '약속된 모닥불',
                              style: Theme.of(context)
                                  .textTheme
                                  .bigHeadLine4!
                                  .copyWith(color: ColorSchemes.gray500),
                            ),
                            TextButton(
                              onPressed: () => Routes.navigateTo(
                                  context, Routes.myModakbulScreen),
                              child: Text(
                                '전체보기',
                                style: Theme.of(context)
                                    .textTheme
                                    .body3!
                                    .copyWith(color: ColorSchemes.gray300),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                      ],
                    ),
                  ),
                  acceptedList.isNotEmpty
                      ? SizedBox(
                    height: 154.h,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: acceptedList.length,
                      itemBuilder: (ctx, i) {
                        final item = acceptedList[i];
                        String date = DateFormat(
                            'MM.dd(E) a h시 m분', 'ko_KR')
                            .format(item.date.add(Duration(hours: 9)));
                        return Padding(
                          padding: EdgeInsets.only(
                              right: i == acceptedList.length - 1
                                  ? 0
                                  : 8.w),
                          child: GestureDetector(
                            onTap: () => Routes.navigateTo(
                              context,
                              Routes.modakbulDetailScreen,
                              arguments: {
                                'id': item.id,
                                'isAccepted': true
                              },
                            ),
                            behavior: HitTestBehavior.opaque,
                            child: FixedModakbulCard(
                              title: item.title,
                              date: date,
                              location: item.address,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Column(
                      children: [
                        Text(
                          '더이상 모닥불이 없습니다.',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine3!
                              .copyWith(color: ColorSchemes.orange100),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '모닥불을 참여해보세요',
                          style: Theme.of(context)
                              .textTheme
                              .body2!
                              .copyWith(color: ColorSchemes.gray300),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            } else {
              return DefaultTabScreenSkeleton();
            }
          },
        ),
      ),
    );
  }
}
