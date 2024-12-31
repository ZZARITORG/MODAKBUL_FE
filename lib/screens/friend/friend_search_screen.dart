import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/models/friend_suggested.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/user_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/screens/friend/add_freind_screen.dart';
import 'package:modakbul/screens/search/search_screen.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';
import 'package:modakbul/widgets/add_friend_profile.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/participant_list_profile.dart';
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
  final FocusNode _searchFocusNode = FocusNode();
  UserService userService = UserService();
  FriendService friendService = FriendService();
  List<UserList> userList = [];
  List<Map<String, String>> selectedFriends = [];
  List<FriendSuggested> friendSuggested = [];
  List<FriendReqList> friendRequests = [];
  List<bool> isPressedList = [];
  late Future<List<UserList>> getUser;
  late Future<UserCheck> getUserCheck;
  late Future<List<FriendSuggested>> getSug;
  late Future<List<FriendReqList>> getReq;
  late DateTime currentTime;
  bool isSearching = false;
  bool isPressed = true;
  Timer? _debounce;

  List<UserList> displayedUsers = []; // 화면에 표시할 데이터
  int _currentPage = 0; // 현재 페이지
  final int _pageSize = 20; // 한 페이지에 표시할 데이터 수
  bool _isLoadingMore = false; // 추가 데이터를 로드 중인지 여부

  @override
  void initState() {
    super.initState();
    getReq = friendService.getFriendReqList();
    getSug = friendService.getFriendSuggested();
    _initializeCurrentTime();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initializeCurrentTime() async {
    currentTime = await DateTimeUtils.getKoreaTime();
    setState(() {}); // currentTime을 업데이트하고 화면을 리빌드
  }

  Future<void> _fetchAllUsers(String query) async {
    setState(() {
      _isLoadingMore = true; // 로딩 상태 표시
    });
    try {
      final users = await userService.getUserList(query); // 전체 데이터 받아오기
      setState(() {
        userList = users; // 전체 데이터를 저장
        _currentPage = 0; // 페이지 초기화
        displayedUsers = userList.take(_pageSize).toList(); // 첫 페이지 데이터만 표시
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다: $error')),
      );
    } finally {
      setState(() {
        _isLoadingMore = false; // 로딩 상태 종료
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (query.isNotEmpty) {
        setState(() {
          isSearching = true;
          getUser = userService.getUserList(query);
          userList.clear();
          displayedUsers.clear();
          _currentPage = 0;
        });
        _fetchAllUsers(query);
      } else {
        setState(() {
          isSearching = false;
          userList.clear();
          displayedUsers.clear();
          _currentPage = 0;
        });
      }
    });
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
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    CustomSearchBar(
                      hintText: '사용자를 검색해보세요.',
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                    ),
                  ],
                ),
              ),
              isSearching
                  ? _buildSearchResults()
                  : _buildFriendRequests(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (displayedUsers.isEmpty || !isSearching) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          children: [
            SizedBox(height: 132.h),
            Text(
              '검색 결과가 없습니다.',
              style: Theme.of(context)
                  .textTheme
                  .bigHeadLine3
                  .copyWith(color: ColorSchemes.orange100),
            ),
            SizedBox(height: 8.h),
            Text(
              '검색어를 다시 확인해 주세요',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.gray300),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
      child: Column(
        children: [
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Row(
              children: [
                Text(
                  '검색결과',
                  style: Theme.of(context)
                      .textTheme
                      .bigHeadLine4
                      .copyWith(color: ColorSchemes.gray500),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            primary: false,
            itemCount: displayedUsers.length + 1,
            itemBuilder: (context, index) {
              if (index < displayedUsers.length) {
                final user = displayedUsers[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    final selectedUser = displayedUsers[index];
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return FutureBuilder<UserCheck>(
                          future: userService.getUserCheck(displayedUsers[index].id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              UserCheck userCheckData = snapshot.data!;
                              print('aaa${userCheckData.status}');
                              if (userCheckData.status == 'BLOCKED') {
                                return SizedBox.shrink();
                              }
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 24.h),
                                    Padding(
                                      padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              IconPath.moreHorizontal,
                                              width: 20.w,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              IconPath.arrowDown,
                                              width: 18.w,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 18.h),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.h, right: 24.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedUser.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bigHeadLine2
                                                      .copyWith(color: ColorSchemes.gray500),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  selectedUser.userId,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body2
                                                      .copyWith(color: ColorSchemes.gray300),
                                                ),
                                                SizedBox(height: 6.h),
                                                Text(
                                                  '함께하는 친구가 10명 있습니다!',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body3
                                                      .copyWith(color: ColorSchemes.gray200),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 37.w), // 고정 간격 추가
                                          CircleAvatar(
                                            radius: StyleConstants.circleSizeL,
                                            backgroundImage: NetworkImage(selectedUser.profileUrl),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56.h,
                                        child: CustomButton(
                                          text: userCheckData.status == 'ACCEPTED' ? '친구 삭제' : '친구 요청',
                                          onPressed: () {
                                            switch (userCheckData.status) {
                                              case 'ACCEPTED' :
                                                friendService.deleteFriend(Uuid(targetId: selectedUser.id));
                                                break;
                                              case 'REJECTED' :
                                                friendService.rejectFriend(Uuid(targetId: selectedUser.id));
                                                break;
                                              case 'NONE' :
                                                friendService.requestFriend(Uuid(targetId: selectedUser.id));
                                                break;
                                            }
                                          },
                                          buttonColor: ColorSchemes.orange200,
                                          textStyle: Theme.of(context).textTheme.smallHeadLine2,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 56.h),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  child: Participantlistprofile(
                    userName: user.name,
                    userId: user.userId,
                    profileImage: user.profileUrl,
                  ),
                );
              } else if (_isLoadingMore) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFriendRequests() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
      child: Column(
        children: [
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
                              AddFreindScreen()),
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
            future: getReq,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator()); // 로딩 중일 때 표시
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Error: ${snapshot.error}')); // 에러 발생 시 표시
              } else if (!snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    '친구요청이 없습니다.',
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: ColorSchemes.gray300),
                  ),
                ); // 데이터가 없을 때 표시
              } else {
                friendRequests = snapshot.data!;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: friendRequests.length >= 2
                      ? 2
                      : friendRequests.length,
                  itemBuilder: (context, index) {
                    final friend = friendRequests[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: AddFriendProfile(
                        profileImage: friend.profileUrl,
                        userName: friend.name,
                        userId: friend.userId,
                        time: timeAgo(friend.createdAt, currentTime),
                        acceptOnPressed: () async {
                          await friendService.acceptFriend(
                              Uuid(targetId: friend.id));
                          setState(() {
                            friendRequests.removeWhere(
                                    (request) => request.id == friend.id);
                          });
                        },
                        rejectOnPressed: () async {
                          await friendService.rejectFriend(
                              Uuid(targetId: friend.id));
                          setState(() {
                            friendRequests.removeWhere(
                                    (request) => request.id == friend.id);
                          });
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
          SizedBox(height: 24.h),
          Divider(
            thickness: 2.h,
            height: 2.h,
            color: ColorSchemes.gray100,
          ),
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
            future: getSug, // 비동기 데이터를 가져오는 Future
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator()); // 로딩 중
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Error: ${snapshot.error}')); // 에러 발생 시 표시
              } else if (!snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    '추천된 친구가 없습니다.',
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: ColorSchemes.gray300),
                  ),);
              } else {
                friendSuggested = snapshot.data!;
                isPressedList = List<bool>.filled(friendSuggested.length, true);
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: friendSuggested.length,
                  itemBuilder: (context, index) {
                    final friend = friendSuggested[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == friendSuggested.length - 1
                            ? 0
                            : 20.h,
                      ),
                      child: SuggestedFriendProfile(
                        profileImage: friend.profileUrl,
                        userName: friend.name,
                        isPressed: isPressedList[index],
                        mutualFriendCount: friend.mutualFriendCount.toString(),
                        acceptOnPressed: () async {
                          if (isPressedList[index]) {
                            await friendService.requestFriend(Uuid(targetId: friend.id));
                          } else {
                            await friendService.deleteFriend(Uuid(targetId: friend.id));
                          }
                          setState(() {
                            isPressedList[index] = !isPressedList[index];
                          });
                        },
                        rejectOnPressed: () async {
                          await friendService.deleteFriend(Uuid(targetId: friend.id));
                          setState(() {
                            friendSuggested.removeWhere((request) => request.id == friend.id);
                          });
                        },
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
    );
  }
}
