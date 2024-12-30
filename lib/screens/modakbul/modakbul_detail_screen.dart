import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/accept_modakbul.dart';
import 'package:modakbul/models/blocked_user.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/modakbul_detail_card.dart';
import 'package:modakbul/widgets/modakbul_detail_screen_skeleton.dart';

import '../../models/modakbul_detail.dart';
import '../../routes/routes.dart';
import '../../themes/color_schemes.dart';

class ModakbulDetailScreen extends StatefulWidget {
  const ModakbulDetailScreen({super.key});

  @override
  State<ModakbulDetailScreen> createState() => _ModakbulDetailScreenState();
}

class _ModakbulDetailScreenState extends State<ModakbulDetailScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Set<Marker> markers = {};
  late KakaoMapController mapController;

  MeetingService meetingService = MeetingService();
  FriendService friendService = FriendService();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? id = arguments?['id'];

    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: FutureBuilder<List>(
            future: Future.wait([
              meetingService.getModakbulDetail(id!),
              friendService.getBlockedUser().catchError((error){
                return <BlockedUser>[];
              }),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ModakbulDetailScreenSkeleton();
              } else if (snapshot.hasError) {
                return Text('에러');
              } else if (snapshot.hasData) {
                final modakbulDetailData = snapshot.data![0];
                List<BlockedUser> blockedUsersData = snapshot.data![1] ?? [];

                String hostId = modakbulDetailData!.hostId;
                String title = modakbulDetailData!.title;
                String content = modakbulDetailData!.content;
                String address = modakbulDetailData!.address;

                DateTime utcDate = modakbulDetailData!.date;
                DateTime kstDate = utcDate.add(Duration(hours: 9));
                Intl.defaultLocale = 'ko_KR';
                String date = DateFormat('MM.dd(E) a h시 m분').format(kstDate);

                List<UserStatus> users = modakbulDetailData!.users;
                UserStatus host = users.firstWhere(
                      (user) => user.id == hostId,
                );
                List<UserStatus> participantUsers =
                users.where((user) => user.id != hostId).toList();
                double lat = modakbulDetailData!.lat;
                double lng = modakbulDetailData!.lng;

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: StyleConstants.defaultPadding),
                      child: Column(
                        children: [
                          ModakbulDetailCard(
                            hostName: host.name,
                            hostId: host.userId,
                            hostProfileImage: host.profileUrl,
                            participantLength: users.length,
                            users: users,
                            participantUsers: participantUsers,
                            blockedUsers: blockedUsersData,
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20.r,
                                            height: 20.r,
                                            child: SvgPicture.asset(
                                              IconPath.timeOrange200,
                                              width: 16.r,
                                              height: 16.r,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Text(
                                            date,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                                .copyWith(
                                                color:
                                                ColorSchemes.orange200,
                                                height: 1.5),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        title,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bigHeadLine3
                                            .copyWith(
                                          color: ColorSchemes.gray500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        content,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .copyWith(
                                            color: ColorSchemes.gray400,
                                            height: 26 / 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 32.h,
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '위치',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bigHeadLine4
                                                  .copyWith(
                                                  color:
                                                  ColorSchemes.gray400,
                                                  height: 1.193),
                                            ),
                                            GestureDetector(
                                              onTap: () => Routes.navigateTo(
                                                  context,
                                                  Routes
                                                      .modakbulMapDetailScreen,
                                                  arguments: {
                                                    'address': address,
                                                    'lat': lat,
                                                    'lng': lng,
                                                  }),
                                              behavior: HitTestBehavior.opaque,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '상세 보기',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .body2
                                                        .copyWith(
                                                        color: ColorSchemes
                                                            .gray200,
                                                        height: 1.5),
                                                  ),
                                                  SizedBox(
                                                    width: 6.w,
                                                  ),
                                                  SvgPicture.asset(
                                                    IconPath
                                                        .arrowForward15Gray200,
                                                    width: 8.r,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 14.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 118.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                StyleConstants.radiusMedium),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x40F3F3F3),
                                                offset: Offset(0, 4),
                                                blurRadius: 10,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                StyleConstants.radiusMedium),
                                            child: StatefulBuilder(
                                                builder: (context, setInState) {
                                                  return KakaoMap(
                                                    onMapCreated:
                                                    ((controller) async {
                                                      mapController = controller;
                                                      markers.add(Marker(
                                                        markerId:
                                                        UniqueKey().toString(),
                                                        latLng: await mapController
                                                            .getCenter(),
                                                        width: 18,
                                                        height: 18,
                                                        offsetX: 20,
                                                        offsetY: 20,
                                                      ));
                                                      setInState(() {});
                                                    }),
                                                    markers: markers.toList(),
                                                    center: LatLng(lat, lng),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                address,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body3
                                                    .copyWith(
                                                    color: ColorSchemes
                                                        .gray300,
                                                    height: 1.571),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(
                                                  ClipboardData(text: address));
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  IconPath.copy,
                                                  width: 15.r,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  '복사',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body3
                                                      .copyWith(
                                                      color: ColorSchemes
                                                          .orange100,
                                                      height: 1.571),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 88.h,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 16.h,
                        right: 16.h,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 72.h,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 37.h,
                                color: ColorSchemes.gray000,
                              ),
                            ),
                            Positioned(
                                bottom: 16.h,
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  height: 56.h,
                                  child: CustomButton(
                                      text: '모닥불 참여하기',
                                      onPressed: () async {
                                        Logger logger = Logger();
                                        logger.i('아이디아이다 ----는 $id');
                                        final acceptModakbul = AcceptModakbul(meetingId: modakbulDetailData!.id);
                                        await meetingService.acceptModakbul(acceptModakbul);
                                        Routes.navigateAndRemoveUntil(context, Routes.mainScreen);
                                      },
                                      buttonColor: ColorSchemes.orange200,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .smallHeadLine2,
                                      textColor: ColorSchemes.white),
                                )),
                          ],
                        ))
                  ],
                );
              } else {
                return Text('머야 이거');
              }
            }
            ),
      ),
    );
  }
}
