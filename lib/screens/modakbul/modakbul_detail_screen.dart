import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/modakbul_detail_card.dart';
import 'package:modakbul/widgets/modakbul_detail_screen_skeleton.dart';

import '../../models/modakbul_detail.dart';
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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? id = arguments?['id'];
    Logger logger = Logger(
      printer: PrettyPrinter(),
    );
    logger.i('넝머온 id는 $id 입니다 ');

    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: meetingService.getModakbulDetail(id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ModakbulDetailScreenSkeleton();
              } else if (snapshot.hasError) {
                return Text('에러');
              } else if (snapshot.hasData) {
                final modakbulDetailData = snapshot.data!;

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

                double lat = modakbulDetailData!.lat;
                double lng = modakbulDetailData!.lng;
                logger.i('위도 경도는 이거다잉 $lat이랑 $lng');

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: StyleConstants.defaultPadding),
                      child: /*Skeleton 들어갈 자리 */
                          Column(
                        children: [
                          ModakbulDetailCard(
                              userName: host.name,
                              userId: host.userId,
                              posterProfileImage: host.profileUrl,
                              profileLength: users.length - 1,
                              participantProfileImage:
                                  'participantProfileImage'),
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
                                              onTap: () {},
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
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x40F3F3F3),
                                                  offset: Offset(0, 4),
                                                  blurRadius: 10,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                              ),
                                          child: StatefulBuilder(
                                            builder: (context, setInState) {
                                              return KakaoMap(
                                                onMapCreated: ((controller) async {
                                                  mapController = controller;
                                                  markers.add(Marker(
                                                    markerId: UniqueKey().toString(),
                                                    latLng: await mapController.getCenter(),
                                                  ));
                                                  setInState(() {});
                                                }),
                                                markers: markers.toList(),
                                                center: LatLng(lat, lng),

                                              );
                                            }
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
                                            onTap: () {},
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
                                      onPressed: () {},
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
            }),
      ),
    );
  }
}
