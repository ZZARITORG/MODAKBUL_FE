import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/models/friend_suggested.dart';
import 'package:modakbul/screens/friend/add_freind_screen.dart';
import 'package:modakbul/services/friend_req_service.dart';
import 'package:modakbul/services/friend_suggested_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';
import 'package:modakbul/widgets/add_friend_profile.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/search_screen_skeleton.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:modakbul/widgets/suggested_friend_profile.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';
import '../../constants/assets_path.dart';
import '../../constants/style_constants.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/logo_app_bar.dart';
import 'create_group_screen.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FriendReqService friendReqService = FriendReqService();
  List<FriendReqList> friendRequests = [];
  late Future<List<FriendReqList>> getData;
  FriendSuggestedService friendSuggestedService = FriendSuggestedService();
  List<FriendSuggested> friendSuggested = [];
  late Future<List<FriendSuggested>> getList;
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    getData = friendReqService.getFriendReqList();
    getList = friendSuggestedService.getFriendSuggested();
    _initializeCurrentTime();  // 비동기 메서드 호출
  }

  // 비동기 메서드를 따로 분리
  Future<void> _initializeCurrentTime() async {
    currentTime = await DateTimeUtils.getKoreaTime();
    setState(() {});  // currentTime을 업데이트하고 화면을 리빌드
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static String timeAgo(DateTime dateTime, DateTime currentTime) {
    Duration difference = currentTime.difference(dateTime); // 시간 차이 계산

    if (difference.inDays > 0) {
      // 하루 이상 차이 나면 "몇 일 전" 형태로 출력
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      // 한 시간 이상 차이 나면 "몇 시간 전" 형태로 출력
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      // 1분 이상 차이 나면 "몇 분 전" 형태로 출력
      return '${difference.inMinutes}분 전';
    } else {
      // 1분 이내로 차이가 나면 "방금 전" 형태로 출력
      return '방금 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: /*Skeleton 들어갈 자리 */ SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: StyleConstants.defaultPadding),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    CustomSearchBar(
                      hintText: '사용자를 검색해보세요.',
                      controller: _searchController,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(width: 4.w),
                        Text(
                          '친구요청',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine4
                              .copyWith(color: ColorSchemes.gray500),
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddFreindScreen()), // AddFreindScreen 으로 이동해야함
                              );
                            },
                            child: Text(
                              '전체보기',
                              style: Theme.of(context)
                                  .textTheme
                                  .body3
                                  .copyWith(color: ColorSchemes.orange200),
                            )),
                        SizedBox(width: 4.w),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    FutureBuilder<List<FriendReqList>>(
                      future: getData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator()); // 로딩 중일 때 표시
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}')); // 에러 발생 시 표시
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No friend requests available.')); // 데이터가 없을 때 표시
                        } else {
                          friendRequests = snapshot.data!;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: friendRequests.length >= 3 ? 3 : friendRequests.length,
                            itemBuilder: (context, index) {
                              final friend = friendRequests[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
                                child: AddFriendProfile(
                                  profileImage: friend.profileUrl,
                                  userName: friend.name,
                                  userId: friend.userId,
                                  time: timeAgo(friend.createdAt, currentTime),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2.h,
                height: 2.h,
                color: ColorSchemes.gray100,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: StyleConstants.defaultPadding),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        SizedBox(width: 4.w),
                        Text(
                          '알 수도 있는 사람',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine4
                              .copyWith(color: ColorSchemes.gray500),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    FutureBuilder<List<FriendSuggested>>(
                      future: getList, // 비동기 데이터를 가져오는 Future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator()); // 로딩 중
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}')); // 에러 발생 시 표시
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('추천된 친구가 없습니다.')); // 데이터가 없을 때 표시
                        } else {
                          friendSuggested = snapshot.data!; // 데이터가 있을 경우 사용
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: friendSuggested.length,
                            itemBuilder: (context, index) {
                              final friend = friendSuggested[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == friendSuggested.length - 1 ? 0 : 24.h,
                                ),
                                child: SuggestedFriendProfile(
                                  profileImage: friend.profileUrl,
                                  userName: friend.name,
                                  mutualFriendCount: friend.mutualFriendCount.toString(),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 84.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
