import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/contacts.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/models/friend_suggested.dart';
import 'package:modakbul/models/my_profile.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/user_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/screens/friend/add_freind_screen.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';
import 'package:modakbul/utils/json_utils.dart';
import 'package:modakbul/widgets/add_friend_profile.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';
import 'package:modakbul/widgets/participant_list_profile.dart';
import 'package:modakbul/widgets/profile_bottom_sheet.dart';
import 'package:modakbul/widgets/suggested_friend_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  final paginationThrottle = Throttle(Duration(milliseconds: 300), initialValue: 1, checkEquality: false);
  UserService userService = UserService();
  FriendService friendService = FriendService();
  List<UserList> userList = [];
  List<Map<String, String>> selectedFriends = [];
  List<FriendSuggested> friendSuggested = [];
  List<FriendReqList> friendRequests = [];
  List<FriendList> friendList = [];
  late Future<UserCheck> getUserCheck;
  late Future<List<FriendSuggested>> getSug;
  late Future<List<FriendReqList>> getReq;
  late DateTime currentTime;
  late AnimationController _lottieController;
  Timer? _debounce;
  bool isLoading = false;
  bool isSearching = false;
  bool showLottie = false;
  bool isEnd = false;
  int page = 1;

  Future<void> getContacts() async {
    List<String> contactNumbers = [];
    final prefs = await SharedPreferences.getInstance();
    List<String> delSugList = prefs.getStringList('delSugList') ?? [];
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contactNumbers = contacts
            .where((contact) => contact.phones.isNotEmpty)
            .map((contact) => contact.phones[0].number)
            .toList();
        getSug = friendService.getFriendSuggested(Contacts(contacts: contactNumbers))
            .then((suggestions) {
          return suggestions.where((friend) => !delSugList.contains(friend.id)
          ).toList();
        });
      });
    } else {
      print('Permission denied');
    }
  }

  @override
  void initState() {
    super.initState();
    getReq = friendService.getFriendReqList();
    getSug = friendService.getFriendSuggested(Contacts(contacts: []));
    getContacts();
    _initializeCurrentTime();
    _lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _lottieController.repeat();
    _searchController.addListener(onSearchChanged);
    _scrollController.addListener(onScroll);
  }

  Future<void> _initializeCurrentTime() async {
    currentTime = await DateTimeUtils.getKoreaTime();
    setState(() {});
  }

  Future<void> fetchAllUsers(String query) async {
    try {
      final response = await userService.getUserList(query, page: 1);
      List<UserList> users = JsonUtils().parseUserList(response['users'] as List);
      if (query.isNotEmpty) {
        MyProfile myProfile = await userService.getMyProfile();
        users = users.where((user) => user.userId != myProfile.userId).toList();
      }
      setState(() {
        userList = users;
        isEnd = response['isEnd'];
        page ++;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다: $error')),
      );
    }
  }

  void updateFriendStatus(String userId) {
    setState(() {
      getSug = getSug;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  void onScroll() async {
    if (!isEnd) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
            showLottie = true;
          });
          _lottieController.repeat();
          final response = await userService.getUserList(
              _searchController.text.trim(), page: page);
          List<UserList> newUsers = JsonUtils().parseUserList(response['users'] as List);
          isEnd = response['isEnd'];
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            userList.addAll(newUsers);
            page++;
            isLoading = false;
            showLottie = false;
          });
          _lottieController.stop();
        }
      }
    }
  }

  void onSearchChanged() {
    final query = _searchController.text.trim();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          isSearching = true;
          page = 1;
        });
        fetchAllUsers(query);
      } else {
        setState(() {
          isSearching = false;
        });
      }
    });
  }

  static String timeAgo(DateTime dateTime, DateTime currentTime) {
    Duration difference = currentTime.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: StyleConstants.defaultPadding),
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  CustomSearchBar(
                    hintText: '사용자를 검색해 보세요.',
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Expanded(
              child: isSearching
                  ? _buildSearchResults()
                  : _buildFriendRequests(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (userList.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: StyleConstants.defaultPadding),
        child: Column(
          children: [
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Row(
                children: [
                  Text(
                    '검색결과',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bigHeadLine4
                        .copyWith(color: ColorSchemes.gray500),
                  ),
                ],
              ),
            ),
            SizedBox(height: 144.h),
            Text(
              '검색 결과가 없습니다',
              style: Theme
                  .of(context)
                  .textTheme
                  .bigHeadLine3
                  .copyWith(color: ColorSchemes.orange100),
            ),
            SizedBox(height: 8.h),
            Text(
              '검색어를 다시 확인해 주세요.',
              style: Theme
                  .of(context)
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
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Row(
              children: [
                Text(
                  '검색결과',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bigHeadLine4
                      .copyWith(color: ColorSchemes.gray500),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: userList.length + (showLottie ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < userList.length) {
                      final user = userList[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          final selectedUser = userList[index];
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return FutureBuilder<UserCheck>(
                                future: userService.getUserCheck(
                                    userList[index].id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text(
                                        'Error: ${snapshot.error}'));
                                  } else {
                                    UserCheck userCheckData = snapshot.data!;
                                    if (userCheckData.status == 'BLOCKED') {
                                      return SizedBox.shrink();
                                    }
                                    return ProfileBottomSheet(
                                        userCheckData: userCheckData,
                                        selectedUserId: selectedUser.id,
                                        friendService: friendService
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
                    } else if (index == userList.length && showLottie) {
                      return SizedBox(
                        height: 72.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 14.h, bottom: 26.h),
                          // 위쪽 14, 아래쪽 26 간격
                          child: Center(
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: Lottie.asset(
                                controller: _lottieController,
                                AnimationPath.loadingFeed,
                                fit: BoxFit.contain,
                                repeat: true,
                                animate: true,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFriendRequests() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: StyleConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),
            Row(
              children: [
                SizedBox(width: 4.w),
                Text(
                  '친구요청',
                  style: Theme
                      .of(context)
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
                          builder: (context) => AddFreindScreen()),
                    );
                  },
                  child: Text(
                    '전체보기',
                    style: Theme
                        .of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.orange200),
                  ),
                ),
                SizedBox(width: 4.w),
              ],
            ),
            SizedBox(height: 14.h),
            FutureBuilder<List<FriendReqList>>(
              future: getReq,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          '아직 친구가 없어요',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bigHeadLine3
                              .copyWith(color: ColorSchemes.orange100),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: Text(
                          '친구를 추가하고 모닥불을 피워보세요.',
                          style: Theme
                              .of(context)
                              .textTheme
                              .body2
                              .copyWith(color: ColorSchemes.gray300),
                        ),
                      ),
                      SizedBox(height: 28.h),
                    ],
                  );
                } else {
                  friendRequests = snapshot.data!;
                  return Column(
                    children: List.generate(
                      friendRequests.length >= 2 ? 2 : friendRequests.length,
                          (index) {
                        final friend = friendRequests[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return FutureBuilder<UserCheck>(
                                    future: userService.getUserCheck(
                                        friend.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text(
                                            'Error: ${snapshot.error}'));
                                      } else {
                                        UserCheck userCheckData = snapshot.data!;
                                        if (userCheckData.status == 'BLOCKED') {
                                          return SizedBox.shrink();
                                        }
                                        return ProfileBottomSheet(
                                            userCheckData: userCheckData,
                                            selectedUserId: friend.id,
                                            friendService: friendService
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            child: AddFriendProfile(
                              profileImage: friend.profileUrl,
                              userName: friend.name,
                              userId: friend.userId,
                              time: timeAgo(friend.updatedAt, currentTime),
                              acceptOnPressed: () async {
                                await friendService.acceptFriend(
                                    Uuid(targetId: friend.id));
                                setState(() {
                                  friendRequests.removeWhere((
                                      request) => request.id == friend.id);
                                  friendSuggested.removeWhere((
                                      suggested) => suggested.id == friend.id);
                                });
                              },
                              rejectOnPressed: () async {
                                await friendService.rejectFriend(
                                    Uuid(targetId: friend.id));
                                setState(() {
                                  friendRequests.removeWhere((
                                      request) => request.id == friend.id);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Divider(
              thickness: 2.h,
              height: 2.h,
              color: ColorSchemes.gray100,
            ),
            SizedBox(height: 28.h),
            Row(
              children: [
                SizedBox(width: 4.w),
                Text(
                  '알 수도 있는 사람',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bigHeadLine4
                      .copyWith(color: ColorSchemes.gray500),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            FutureBuilder<List<FriendSuggested>>(
              future: getSug,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          '추천 친구가 없어요',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine3
                              .copyWith(color: ColorSchemes.orange100),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: Text(
                          '친구를 추가하고 모닥불을 피워보세요.',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: ColorSchemes.gray300),
                        ),
                      ),
                      SizedBox(height: 28.h),
                    ],
                  );
                } else {
                  List<FriendSuggested> friendSuggested = snapshot.data!;
                  return Column(
                    children: List.generate(
                      friendSuggested.length,
                          (index) {
                        final friend = friendSuggested[index];
                        return FutureBuilder<UserCheck>(
                          future: userService.getUserCheck(friend.id),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox.shrink();
                            } else if (userSnapshot.hasError) {
                              return Center(child: Text('Error: ${userSnapshot.error}'));
                            } else {
                              UserCheck userCheckData = userSnapshot.data!;
                              if (userCheckData.status == 'BLOCKED') {
                                return SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.only(bottom: index == friendSuggested.length - 1 ? 0 : 24.h),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    // 모달 바텀 시트 호출
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return FutureBuilder<UserCheck>(
                                          future: userService.getUserCheck(friend.id), // 최신 상태 가져오기
                                          builder: (context, userSnapshot) {
                                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                                              return Center(child: CircularProgressIndicator());
                                            } else if (userSnapshot.hasError) {
                                              return Center(child: Text('Error: ${userSnapshot.error}'));
                                            } else {
                                              UserCheck userCheckData = userSnapshot.data!;
                                              return ProfileBottomSheet(
                                                userCheckData: userCheckData,
                                                selectedUserId: friend.id,
                                                friendService: friendService,
                                                onFriendStatusChanged: updateFriendStatus,
                                              );
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: SuggestedFriendProfile(
                                    profileImage: friend.profileUrl,
                                    userName: friend.name,
                                    mutualFriendCount: friend.mutualFriendCount.toString(),
                                    userId: friend.id,
                                    userCheckData: userCheckData,
                                    requestFriend: friendService.requestFriend,
                                    deleteFriend: friendService.deleteFriend,
                                    onFriendStatusChanged: (newStatus) {
                                      // 필요한 경우 상태 변경 처리
                                    },
                                    onReject: () async {
                                      final prefs = await SharedPreferences.getInstance();
                                      List<String> delSugList = prefs.getStringList('delSugList') ?? [];
                                      delSugList.add(friend.id);
                                      await prefs.setStringList('delSugList', delSugList);
                                      // 여기서는 해당 항목만 제거
                                      // 리스트에서 해당 항목 제거 로직
                                    },
                                  )
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 24.h)
          ],
        ),
      ),
    );
  }
}
