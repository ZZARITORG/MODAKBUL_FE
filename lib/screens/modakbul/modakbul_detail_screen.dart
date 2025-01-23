import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/blocked_user.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_toast.dart';
import 'package:modakbul/widgets/detail_screen_bottom_sheet.dart';
import 'package:modakbul/widgets/modakbul_detail_card.dart';
import 'package:modakbul/widgets/modakbul_detail_screen_skeleton.dart';
import 'package:modakbul/widgets/participate_bottom_sheet.dart';
import 'package:modakbul/models/modakbul_detail.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/models/user_check.dart';

class ModakbulDetailScreen extends StatefulWidget {
  const ModakbulDetailScreen({super.key});

  @override
  State<ModakbulDetailScreen> createState() => _ModakbulDetailScreenState();
}

class _ModakbulDetailScreenState extends State<ModakbulDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<Marker> markers = {};
  late KakaoMapController mapController;
  ModakbulDetail? modakbulDetailData;
  UserCheck? hostUserCheck;
  List<BlockedUser> blockedUsersData = [];
  String? myUserId;
  bool isLoading = true;

  MeetingService meetingService = MeetingService();
  FriendService friendService = FriendService();
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final Map<String, dynamic>? arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? id = arguments?['id'];

    try {
      final modakbulDetail = await meetingService.getModakbulDetail(id!);
      final responses = await Future.wait([
        friendService.getBlockedUser(),
        userService.getMyProfile(),
        userService.getUserCheck(modakbulDetail.hostId),
      ]);

      setState(() {
        modakbulDetailData = modakbulDetail;
        blockedUsersData = (responses[0] as List<dynamic>?)?.cast<BlockedUser>() ?? [];
        myUserId = (responses[1] as dynamic).userId as String;
        hostUserCheck = responses[2] as UserCheck;
        isLoading = false;
      });

      final participantUsers = modakbulDetailData!.users
          .where((user) => user.id != modakbulDetailData!.hostId)
          .toList();

      bool hasBlockedParticipant = participantUsers.any(
              (participant) => blockedUsersData.any(
                  (blockedUser) => blockedUser.id == participant.id
          )
      );

      if (hasBlockedParticipant) {
        CustomToast.showToast(context, '차단된 사용자가 있습니다!', false);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool isAccepted = arguments?['isAccepted'] ?? false;

    if (isLoading || modakbulDetailData == null || hostUserCheck == null) {
      return Scaffold(
        backgroundColor: ColorSchemes.gray000,
        appBar: BackButtonAppBar.actions(
          backgroundColor: ColorSchemes.gray000,
          onActionPressed: () {},
        ),
        body: ModakbulDetailScreenSkeleton(),
      );
    }

    String id = modakbulDetailData!.id;
    String hostId = modakbulDetailData!.hostId;
    String title = modakbulDetailData!.title;
    String content = modakbulDetailData!.content;
    String address = modakbulDetailData!.address;
    String detailAddress = modakbulDetailData!.detailAddress;
    String location = modakbulDetailData!.location;

    DateTime utcDate = modakbulDetailData!.date;
    DateTime kstDate = utcDate.add(const Duration(hours: 9));
    Intl.defaultLocale = 'ko_KR';
    String date = DateFormat('MM.dd(E) a h시 m분').format(kstDate);

    List<UserStatus> users = modakbulDetailData!.users;
    UserStatus host = users.firstWhere((user) => user.id == hostId);
    List<UserStatus> participantUsers = users.where((user) => user.id != hostId).toList();
    double lat = modakbulDetailData!.lat;
    double lng = modakbulDetailData!.lng;

    bool isHost = myUserId == host.userId;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar.actions(
        backgroundColor: ColorSchemes.gray000,
        onActionPressed: () {
          showModalBottomSheet(
            context: _scaffoldKey.currentContext!,
            builder: (BuildContext context) {
              return DetailScreenBottomSheet(
                isHost: isHost,
                title: title,
                meetingId: id,
              );
            },
          );
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: StyleConstants.defaultPadding),
              child: Column(
                children: [
                  ModakbulDetailCard(
                    hostName: host.name,
                    hostId: host.id,
                    hostUserId: host.userId,
                    hostProfileImage: host.profileUrl,
                    participantLength: users.length,
                    users: users,
                    participantUsers: participantUsers,
                    blockedUsers: blockedUsersData,
                    friendService: friendService,
                    userCheckData: hostUserCheck!,
                    myUserId: myUserId!,
                  ),
                  SizedBox(height: 14.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  SizedBox(width: 4.w),
                                  Text(
                                    date,
                                    style: Theme.of(context).textTheme.body2.copyWith(
                                        color: ColorSchemes.orange200,
                                        height: 1.5),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bigHeadLine3.copyWith(
                                  color: ColorSchemes.gray500,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                content,
                                style: Theme.of(context).textTheme.body2.copyWith(
                                    color: ColorSchemes.gray400,
                                    height: 26 / 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '위치',
                                      style: Theme.of(context).textTheme.bigHeadLine4.copyWith(
                                          color: ColorSchemes.gray400,
                                          height: 1.193),
                                    ),
                                    GestureDetector(
                                      onTap: () => Routes.navigateTo(
                                          context,
                                          Routes.modakbulMapDetailScreen,
                                          arguments: {
                                            'address': address,
                                            'lat': lat,
                                            'lng': lng,
                                            'detailAddress': detailAddress,
                                            'location' : location,
                                          }),
                                      behavior: HitTestBehavior.opaque,
                                      child: Row(
                                        children: [
                                          Text(
                                            '상세 보기',
                                            style: Theme.of(context).textTheme.body2.copyWith(
                                                color: ColorSchemes.gray200,
                                                height: 1.5),
                                          ),
                                          SizedBox(width: 6.w),
                                          SvgPicture.asset(
                                            IconPath.arrowForward15Gray200,
                                            width: 8.r,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 14.h),
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
                                            onMapCreated: ((controller) async {
                                              mapController = controller;
                                              markers.add(Marker(
                                                markerId: UniqueKey().toString(),
                                                latLng: await mapController.getCenter(),
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
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        location,
                                        style: Theme.of(context).textTheme.body3.copyWith(
                                            color: ColorSchemes.gray300,
                                            height: 1.571),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: address));
                                      CustomToast.showToast(context, '주소가 복사되었습니다.', false);
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.copy,
                                          width: 15.r,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          '복사',
                                          style: Theme.of(context).textTheme.body3.copyWith(
                                              color: ColorSchemes.orange100,
                                              height: 1.571),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 88.h),
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
                    SizedBox(height: 72.h),
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
                            child: !isHost
                                ? CustomButton(
                                text: isAccepted ? '모닥불 취소하기' : '모닥불 참여하기',
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext bottomSheetContext) {
                                        return ParticipateBottomSheet(
                                            meetingId: modakbulDetailData!.id,
                                            isAccepted: isAccepted);
                                      });
                                },
                                buttonColor: ColorSchemes.orange200,
                                textStyle: Theme.of(context).textTheme.smallHeadLine2,
                                textColor: ColorSchemes.white)
                                : SizedBox.shrink())),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}