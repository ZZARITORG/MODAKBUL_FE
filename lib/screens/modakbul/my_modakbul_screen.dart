import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/my_modakbul_list_tile.dart';
import 'package:modakbul/widgets/my_modakbul_screen_skeleton.dart';
import 'package:modakbul/models/accepted_modakbul.dart';

import 'package:modakbul/routes/routes.dart';

class MyModakbulScreen extends StatefulWidget {
  const MyModakbulScreen({super.key});

  @override
  State<MyModakbulScreen> createState() => _MyModakbulScreenState();
}

class _MyModakbulScreenState extends State<MyModakbulScreen> {
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  MeetingService meetingService = MeetingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorSchemes.gray000,
        appBar: BackButtonAppBar.actions(
            onActionPressed: () {}, backgroundColor: ColorSchemes.gray000),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: FutureBuilder(
                  future: meetingService.getAcceptedModakbulList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return MyModakbulScreenSkeleton();
                    } else if (snapshot.hasError) {
                      return Text('에러');
                    } else if (snapshot.hasData) {
                      final acceptedModakbulList = snapshot.data!;
                      final acceptedModakbulCount = acceptedModakbulList.length;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24.h,
                            ),
                            SizedBox(
                              width: 205.w,
                              child: Text('약속된 모닥불이\n$acceptedModakbulCount개 있어요',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bigHeadLine2
                                      .copyWith(color: ColorSchemes.gray500)),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text('약속에 참석하기 전 상세내용을 확인해 주세요.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(color: ColorSchemes.gray400)),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            ...acceptedModakbulList.map((modakbul) {
                              int index =
                                  acceptedModakbulList.indexOf(modakbul);
                              String title = acceptedModakbulList[index]!.title;

                              DateTime utcDate =
                                  acceptedModakbulList[index]!.date;
                              DateTime kstDate =
                                  utcDate.add(Duration(hours: 9));
                              Intl.defaultLocale = 'ko_KR';
                              String date = DateFormat('MM.dd(E) a h시 m분')
                                  .format(kstDate);
                              List<UserStatus> users =
                                  acceptedModakbulList[index]!.users;
                              List<UserStatus> participantUsers = users
                                  .where((user) =>
                                      user.id !=
                                      acceptedModakbulList[index]!.hostId)
                                  .toList();

                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Routes
                                        .navigateTo(
                                        context,
                                        Routes
                                            .modakbulDetailScreen,
                                        arguments: {
                                          'id': acceptedModakbulList[
                                          index]
                                              .id,
                                          'isAccepted': true,
                                        }),
                                    child: MyModakbulListTile(
                                      title: title!,
                                      time: date!,
                                      profileLength: users!.length - 1,
                                      participantUsers: participantUsers!,
                                    ),
                                  ),
                                  if (index != acceptedModakbulList.length - 1)
                                    SizedBox(height: 14.h),
                                ],
                              );
                            })
                          ],
                        ),
                      );
                    } else {
                      return Text('머지 이거');
                    }
                  })),
        ));
  }
}
