import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/services/notification_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/alert_list_tile.dart';
import 'package:modakbul/widgets/alert_screen_skeleton.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/models/notifications.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/widgets/global_error_widget.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  NotificationService notificationService = NotificationService();

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

    await notificationService.getNotifications();

    setState(() {
      isLoading = false;
    });
  }

  Map<String, List<Notifications>> categorizeNotifications(
      List<Notifications> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    List<Notifications> sortNotifications(List<Notifications> notifications) {
      return notifications
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 내림차순 정렬 (최신순)
    }

    return {
      '오늘': sortNotifications(notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isAtSameMomentAs(today);
      }).toList()),
      '어제': sortNotifications(notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isAtSameMomentAs(yesterday);
      }).toList()),
      '최근 7일': sortNotifications(notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isBefore(yesterday) && date.isAfter(weekAgo);
      }).toList()),
      '이전 활동': sortNotifications(notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isBefore(weekAgo);
      }).toList()),
    };
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final createdDate = DateTime(time.year, time.month, time.day);

    if (createdDate.isAtSameMomentAs(today)) {
      return '오늘 ${time.hour > 12 ? '오후' : '오전'} ${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (createdDate.isAtSameMomentAs(yesterday)) {
      return '어제 ${time.hour > 12 ? '오후' : '오전'} ${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }

    return '${time.month}월 ${time.day}일 ${time.hour > 12 ? '오후' : '오전'} ${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: CustomRefreshIndicator(
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
                                animate: controller.isLoading,
                              )
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
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
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: FutureBuilder<List<Notifications>>(
              future: notificationService.getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    isLoading == true) {
                  return AlertScreenSkeleton();
                } else if (snapshot.hasError) {
                  return GlobalErrorWidget();
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  isLoading = false;
                  final notificationList = snapshot.data!;
                  final categorizedNotifications =
                      categorizeNotifications(notificationList);

                  return Column(
                    children: [
                      SizedBox(height: 24.h),
                      Expanded(
                        child: ListView(
                          children: categorizedNotifications.entries
                              .where((entry) => entry.value.isNotEmpty)
                              .map((entry) => buildAlertSection(
                                    entry.key,
                                    entry.value,
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 16.h)
                    ],
                  );
                } else {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.only(bottom: (Scaffold.of(context).appBarMaxHeight!).toDouble()),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 132.w,
                            height: 146.h,
                            child: Image.asset(ImagePath.emptyAlert),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Text(
                            '아직 알림이 없습니다.',
                            style: Theme.of(context)
                                .textTheme
                                .bigHeadLine3
                                .copyWith(
                                  color: ColorSchemes.orange100,
                                ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            '알림이 추가되면 알려드리겠습니다.',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                  color: ColorSchemes.gray300,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAlertSection(String date, List<Notifications> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: Theme.of(context)
              .textTheme
              .bigHeadLine3
              .copyWith(color: ColorSchemes.gray500),
        ),
        SizedBox(height: 18.h),
        Column(
          children: notifications.map((notification) {
            return Column(
              children: [
                AlertListTile(
                  title: notification.getTitle(),
                  content: notification.getContent(),
                  alertType: notification.type,
                  time: formatTime(notification.createdAt),
                ),
                SizedBox(height: 12.h),
              ],
            );
          }).toList(),
        ),
        SizedBox(
          height: 24.h,
        )
      ],
    );
  }
}
