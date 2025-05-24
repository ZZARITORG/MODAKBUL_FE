import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/notification_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/alert_list_tile.dart';
import 'package:modakbul/widgets/alert_screen_skeleton.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/global_error_widget.dart';
import 'package:modakbul/models/notifications.dart';
import 'package:intl/date_symbol_data_local.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final NotificationService notificationService = NotificationService();

  static const double _maxDragOffset = 36;
  bool isLoading = true;
  bool isFirstLoading = true;
  bool _wasRefreshing = false;

  late Future<List<Notifications>> _notificationsFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _notificationsFuture =
        notificationService.getNotifications().whenComplete(() {
      setState(() {
        isFirstLoading = false;
      });
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      _notificationsFuture = notificationService.getNotifications();
    });
    await _notificationsFuture;
    setState(() {
      isLoading = false;
    });
  }

  String? _getLoadingAsset(double offset) {
    if (offset < 0.1) return null;
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

  Map<String, List<Notifications>> categorizeNotifications(
      List<Notifications> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    List<Notifications> sortNotifications(List<Notifications> list) {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    }

    return {
      '오늘': sortNotifications(
        notifications.where((n) {
          final local = n.createdAt.toLocal();
          final d = DateTime(local.year, local.month, local.day);
          return d.isAtSameMomentAs(today);
        }).toList(),
      ),
      '어제': sortNotifications(
        notifications.where((n) {
          final local = n.createdAt.toLocal();
          final d = DateTime(local.year, local.month, local.day);
          return d.isAtSameMomentAs(yesterday);
        }).toList(),
      ),
      '최근 7일': sortNotifications(
        notifications.where((n) {
          final local = n.createdAt.toLocal();
          final d = DateTime(local.year, local.month, local.day);
          return d.isBefore(yesterday) && !d.isBefore(weekAgo);
        }).toList(),
      ),
      '이전 활동': sortNotifications(
        notifications.where((n) {
          final local = n.createdAt.toLocal();
          final d = DateTime(local.year, local.month, local.day);
          return d.isBefore(weekAgo);
        }).toList(),
      ),
    };
  }

  String formatTime(DateTime timeUtc) {
    final time = timeUtc.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(time.year, time.month, time.day);

    final meridiem = time.hour >= 12 ? '오후' : '오전';
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');

    if (d.isAtSameMomentAs(today)) {
      return '오늘 $meridiem $hour:$minute';
    } else if (d.isAtSameMomentAs(yesterday)) {
      return '어제 $meridiem $hour:$minute';
    } else {
      return '${time.month}월 ${time.day}일 $meridiem $hour:$minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
      body: CustomRefreshIndicator(
        onRefresh: _refreshData,
        triggerMode: IndicatorTriggerMode.anywhere,
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
                  top: 14.h,
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: Center(
                      child: controller.isLoading
                          ? Lottie.asset(
                              width: 25.r,
                              height: 25.r,
                              AnimationPath.loadingFeed,
                              animate: true,
                            )
                          : _getLoadingAsset(
                                      controller.value * _maxDragOffset) !=
                                  null
                              ? SvgPicture.asset(
                                  _getLoadingAsset(
                                      controller.value * _maxDragOffset)!,
                                  width: 25.r,
                                  height: 25.r,
                                  key: ValueKey<String>(_getLoadingAsset(
                                      controller.value * _maxDragOffset)!),
                                )
                              : const SizedBox.shrink(),
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
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
          child: FutureBuilder<List<Notifications>>(
            future: _notificationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  isFirstLoading) {
                return AlertScreenSkeleton();
              } else if (snapshot.hasError) {
                return GlobalErrorWidget();
              } else if (snapshot.hasData) {
                final list = snapshot.data!;
                isLoading = false;
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 132.w,
                          height: 146.h,
                          child: Image.asset(ImagePath.emptyAlert),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          '아직 알림이 없습니다.',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine3!
                              .copyWith(color: ColorSchemes.orange100),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '알림이 추가되면 알려드리겠습니다.',
                          style: Theme.of(context)
                              .textTheme
                              .body2!
                              .copyWith(color: ColorSchemes.gray300),
                        ),
                      ],
                    ),
                  );
                }
                final sections = categorizeNotifications(list);
                return Column(
                  children: [
                    SizedBox(height: 24.h),
                    Expanded(
                      child: ListView(
                        children: sections.entries
                            .where((e) => e.value.isNotEmpty)
                            .map((e) => _buildSection(e.key, e.value))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              } else {
                return AlertScreenSkeleton();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Notifications> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bigHeadLine3!
              .copyWith(color: ColorSchemes.gray500),
        ),
        SizedBox(height: 18.h),
        ...items.map((notification) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  switch (notification.type) {
                    case 'FRIEND_REQUEST':
                      Routes.navigateTo(context, Routes.addFriendScreen);
                      break;
                    case 'MEETING_ALARM':
                      if (notification.meetingId != null) {
                        Routes.navigateTo(
                          context,
                          Routes.modakbulDetailScreen,
                          arguments: {
                            'id': notification.meetingId,
                            'isAccepted': false
                          },
                        );
                      }
                      break;
                    case 'MEETING_CANCEL_PARTICIPANT':
                      if (notification.meetingId != null) {
                        Routes.navigateTo(
                          context,
                          Routes.modakbulDetailScreen,
                          arguments: {
                            'id': notification.meetingId,
                            'isAccepted': true
                          },
                        );
                      }
                      break;
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: AlertListTile(
                  title: notification.getTitle(),
                  content: notification.getContent(),
                  alertType: notification.type,
                  time: formatTime(notification.createdAt),
                  sourceUserProfileUrl: notification.sourceUserProfileUrl,
                ),
              ),
              SizedBox(height: 12.h),
            ],
          );
        }).toList(),
        SizedBox(height: 24.h),
      ],
    );
  }
}
