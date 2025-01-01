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

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final List<Map<String, dynamic>> todayAlerts = [
    {'type': 'inviteModakbul', 'sender': '김태현', 'time': '오늘 오후 6:09'},
    {'type': 'friendRequest', 'sender': '이태수', 'time': '오늘 오후 6:09'},
    {'type': 'friendRequest', 'sender': '배철현', 'time': '오늘 오후 6:09'},
  ];
  final List<Map<String, dynamic>> yesterdayAlerts = [
    {'type': 'inviteModakbul', 'sender': '이태수', 'time': '어제 오후 6:09'},
    {'type': 'inviteModakbul', 'sender': '김지호', 'time': '어제 오후 6:09'},
    {'type': 'friendRequest', 'sender': '배철현', 'time': '오늘 오후 6:09'},
  ];

  NotificationService notificationService = NotificationService();

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
              child: FutureBuilder(
                  future: notificationService.getNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return AlertScreenSkeleton();
                    } else if (snapshot.hasError) {
                      return Text('에러');
                    } else if (snapshot.hasData) {
                      final notificationList = snapshot.data!;
                      Logger().i('알림 $notificationList');
                      return  Column(
                        children: [
                          SizedBox(height: 24.h),
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                buildAlertSection('오늘', todayAlerts),
                                buildAlertSection('어제', yesterdayAlerts),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 16.h
                          )
                        ],
                      );
                    } else {
                      return Text('이거머야');
                    }
                  }
              )
          ),
        ));
  }

  //알림 날짜별 섹션 분류 + 알림 타입 분류
  Widget buildAlertSection(String date, List<Map<String, dynamic>> alerts) {
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
          children: alerts.map((alert) {
            final String title;
            final String content;

            switch (alert['type']) {
              case 'inviteModakbul':
                title = '회원님에게 모닥불이 도착했어요!';
                content = '${alert['sender']}님이 회원님을 모임에 초대하였습니다.';
                break;
              case 'friendRequest':
                title = '회원님에게 친구 요청이 도착했어요!';
                content = '${alert['sender']}님이 회원님과 친구가 되고 싶어해요!';
                break;
              default:
                title = '알림';
                content = '알림 내용을 확인하라이말라이.';
            }

            return Column(
              children: [
                AlertListTile(
                  title: title,
                  content: content,
                  alertType: alert['type'],
                  time: alert['time'],
                ),
                if (alerts.indexOf(alert) != alert.length - 1)
                  SizedBox(height: 12.h),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
