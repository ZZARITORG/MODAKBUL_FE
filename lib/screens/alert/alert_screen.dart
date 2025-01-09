import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/services/notification_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/alert_list_tile.dart';
import 'package:modakbul/widgets/alert_screen_skeleton.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/models/notifications.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  NotificationService notificationService = NotificationService();

  Map<String, List<Notifications>> categorizeNotifications(List<Notifications> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    return {
      '오늘': notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isAtSameMomentAs(today);
      }).toList(),

      '어제': notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isAtSameMomentAs(yesterday);
      }).toList(),

      '최근 7일': notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isBefore(yesterday) && date.isAfter(weekAgo);
      }).toList(),

      '이전 활동': notifications.where((notification) {
        final date = DateTime(
          notification.createdAt.year,
          notification.createdAt.month,
          notification.createdAt.day,
        );
        return date.isBefore(weekAgo);
      }).toList(),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
          child: FutureBuilder<List<Notifications>>(
            future: notificationService.getNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AlertScreenSkeleton();
              } else if (snapshot.hasError) {
                return Text('에러');
              } else if (snapshot.hasData) {
                final notificationList = snapshot.data!;
                final categorizedNotifications = categorizeNotifications(notificationList);

                return Column(
                  children: [
                    SizedBox(height: 24.h),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
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
              }
              return Text('이거머야');
            },
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
        SizedBox(height: 24.h,)
      ],
    );
  }
}