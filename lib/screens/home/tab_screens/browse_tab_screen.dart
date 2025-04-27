import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/browse_tab_screen_skeleton.dart';
import 'package:modakbul/widgets/global_error_widget.dart';
import 'package:modakbul/widgets/invited_modakbul_card.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/models/pending_modakbul.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:modakbul/providers/location_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/screens/main_screen.dart';

class BrowseTabScreen extends StatefulWidget {
  const BrowseTabScreen({super.key});

  @override
  State<BrowseTabScreen> createState() => _State();
}

class _State extends State<BrowseTabScreen> {
  MeetingService meetingService = MeetingService();

  double? myLat;
  double? myLng;
  Distance distance = Distance();

  static const double _maxDragOffset = 36;
  bool isLoading = true;
  bool _wasRefreshing = false;

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
  void initState() {
    super.initState();
    initializeDateFormatting();

    Position? currentPosition =
        Provider.of<LocationProvider>(context, listen: false).currentPosition;
    myLat = currentPosition?.latitude;
    myLng = currentPosition?.longitude;
  }

  final List<String> filters = ['최신순', '마감 임박', '거리순'];
  final ValueNotifier<String> selectedFilter = ValueNotifier('최신순');

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _maxDragOffset,
      onRefresh: _refreshData,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        if (controller.isLoading && !_wasRefreshing) {
          HapticFeedback.lightImpact();
          _wasRefreshing = true;
        } else if (!controller.isLoading && _wasRefreshing) {
          _wasRefreshing = false;
        }
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
      child: Column(
        children: [
          Expanded(
            child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                child: FutureBuilder(
                    future: meetingService.getPendingModakbulList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return BrowseTabScreenSkeleton();
                      } else if (snapshot.hasError) {
                        return GlobalErrorWidget();
                      } else if (snapshot.hasData) {
                        final pendingModakbulList = snapshot.data!;
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 14.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                                      mainScreenState?.setState(() {
                                        mainScreenState.selectedIndex = 2;
                                      });
                                    });
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('혼자는 너무 춥지 않아?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bigHeadLine4
                                                  .copyWith(
                                                      color: ColorSchemes.orange200)),
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
                                              SvgPicture.asset(
                                                  IconPath.arrowForward15Orange100),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 75.w,
                                        height: 75.h,
                                        child: Image.asset(ImagePath.homeModakbul),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              Column(
                                children: [
                                  ValueListenableBuilder<String>(
                                    valueListenable: selectedFilter,
                                    builder: (context, value, child) {
                                      List<PendingModakbul>
                                          sortedPendingModakbulList =
                                          List.from(pendingModakbulList);
                                      if (value == '최신순') {
                                        sortedPendingModakbulList.sort((a, b) =>
                                            b.createdAt.compareTo(a.createdAt));
                                      } else if (value == '마감 임박') {
                                        sortedPendingModakbulList
                                            .sort((a, b) => a.date.compareTo(b.date));
                                      } else if (value == '거리순') {
                                        if (myLat == null && myLng == null) {
                                          return Center(
                                            child: Text('위치 정보 없다'),
                                          );
                                        }
                                        sortedPendingModakbulList.sort((a, b) {
                                          double distanceA = distance.as(
                                            LengthUnit.Kilometer,
                                            LatLng(myLat!, myLng!),
                                            LatLng(a.lat!, a.lng!),
                                          );
                                          double distanceB = distance.as(
                                            LengthUnit.Kilometer,
                                            LatLng(myLat!, myLng!),
                                            LatLng(b.lat!, b.lng!),
                                          );

                                          return distanceA.compareTo(distanceB);
                                        });
                                      }

                                      return Column(
                                        children: [
                                          Row(
                                              children: filters.map((filter) {
                                            final isSelected = value == filter;
                                            return Padding(
                                              padding: EdgeInsets.only(right: 8.w),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  HapticFeedback.lightImpact();
                                                  if (filter == '거리순' &&
                                                      (myLat == null ||
                                                          myLng == null)) {
                                                    return;
                                                  }
                                                  selectedFilter.value = filter;
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isSelected
                                                      ? ColorSchemes.orange200
                                                      : ColorSchemes.orange000,
                                                  padding: isSelected
                                                      ? EdgeInsets.symmetric(
                                                          vertical: 7.h,
                                                          horizontal: 14.w)
                                                      : EdgeInsets.symmetric(
                                                          vertical: 6.h,
                                                          horizontal: 12.w),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              StyleConstants
                                                                  .radiusMedium)),
                                                ).copyWith(
                                                  backgroundColor: WidgetStateProperty
                                                      .resolveWith<Color>((states) {
                                                    if (states.contains(
                                                        WidgetState.pressed)) {
                                                      return ColorSchemes.orange100;
                                                    }
                                                    return isSelected
                                                        ? ColorSchemes.orange200
                                                        : ColorSchemes.orange000;
                                                  }),
                                                  foregroundColor: WidgetStateProperty
                                                      .resolveWith<Color>((states) {
                                                    if (states.contains(
                                                        WidgetState.pressed)) {
                                                      return ColorSchemes.orange000;
                                                    }
                                                    return isSelected
                                                        ? ColorSchemes.white
                                                        : ColorSchemes.orange100;
                                                  }),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(filter,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .body3),
                                                    if (filter == value)
                                                      SizedBox(
                                                          width: 18.w,
                                                          height: 18.h,
                                                          child: Image.asset(
                                                            ImagePath
                                                                .browseSmallModakbul,
                                                          )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList()),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          pendingModakbulList.length > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      pendingModakbulList.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    final pendingModakbulData =
                                                        sortedPendingModakbulList[
                                                            index];
                                                    String hostId =
                                                        pendingModakbulData!.hostId;
                                                    String title =
                                                        pendingModakbulData!.title;
                                                    String content =
                                                        pendingModakbulData!.content;
                                                    String address =
                                                        pendingModakbulData!.address;

                                                    DateTime utcDate =
                                                        pendingModakbulData!.date;
                                                    DateTime kstDate = utcDate
                                                        .add(Duration(hours: 9));
                                                    Intl.defaultLocale = 'ko_KR';
                                                    String date =
                                                        DateFormat('MM.dd(E) a h시 m분')
                                                            .format(kstDate);
                                                    List<UserStatus> users =
                                                        pendingModakbulData!.users;
                                                    UserStatus? host =
                                                        users.firstWhere(
                                                            (user) =>
                                                                user.id == hostId,
                                                            orElse: () => UserStatus(
                                                                id: '',
                                                                userId: '알 수 없음',
                                                                name: '알 수 없음',
                                                                profileUrl: '',
                                                                status: ''));
                                                    List<UserStatus>
                                                        participantUsers = users
                                                            .where((user) =>
                                                                user.id != hostId)
                                                            .toList();

                                                    return GestureDetector(
                                                      onTap: () => Routes.navigateTo(
                                                          context,
                                                          Routes.modakbulDetailScreen,
                                                          arguments: {
                                                            'id':
                                                                sortedPendingModakbulList[
                                                                        index]
                                                                    .id
                                                          }),
                                                      behavior:
                                                          HitTestBehavior.opaque,
                                                      child: Padding(
                                                        padding: index !=
                                                                pendingModakbulList
                                                                        .length -
                                                                    1
                                                            ? EdgeInsets.only(
                                                                bottom: 12.h)
                                                            : EdgeInsets.only(
                                                                bottom: 0.h),
                                                        child: InvitedModakbulCard(
                                                            hostProfileImage:
                                                                host.profileUrl,
                                                            participantLength:
                                                                users.length - 1,
                                                            hostName: host.name,
                                                            hostId: host.userId,
                                                            title: title,
                                                            content: content,
                                                            date: date,
                                                            address: address,
                                                            participantUsers:
                                                                participantUsers),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 120.h,
                                                    ),
                                                    Text(
                                                      '초대된 모닥불이 없습니다.',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bigHeadLine3
                                                          .copyWith(
                                                              color: ColorSchemes
                                                                  .orange100),
                                                    ),
                                                    Text(
                                                      '초대가 오면 알림을 보내드리겠습니다.',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .body2
                                                          .copyWith(
                                                              color: ColorSchemes
                                                                  .gray300),
                                                    ),
                                                  ],
                                                )
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return Text('머지이거');
                      }
                    })),
          ),
        ],
      ),
    );
  }
}
