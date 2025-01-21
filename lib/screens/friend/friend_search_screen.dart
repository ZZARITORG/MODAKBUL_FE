import 'dart:async';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/models/contacts.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/models/friend_suggested.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/user_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/screens/friend/add_freind_screen.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/assets_path.dart';
import '../../constants/style_constants.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/logo_app_bar.dart';
import 'create_group_screen.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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
  late List<bool> isPressedList = [];
  List<String> filteredData = [];
  late Future<List<UserList>> getUser;
  late Future<UserCheck> getUserCheck;
  late Future<List<FriendSuggested>> getSug;
  late Future<List<FriendReqList>> getReq;
  late DateTime currentTime;
  late AnimationController _lottieController;
  Timer? _debounce;
  bool isLoading = false;
  bool isSearching = false;
  bool showLottie = false;
  int page = 1;

  Future<void> getContacts() async {
    List<String> contactNumbers = [];
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contactNumbers = contacts
            .where((contact) => contact.phones.isNotEmpty)
            .where((contact) => contact.phones.isNotEmpty)
            .map((contact) => contact.phones[0].number)
            .toList();
      });
    } else {
      print('Permission denied');
    }
    getSug = friendService.getFriendSuggested(Contacts(contacts: contactNumbers));
  }

  @override
  void initState() {
    super.initState();
    getReq = friendService.getFriendReqList();
    getContacts();
    _initializeCurrentTime();
    _lottieController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
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
      final users = await userService.getUserList(query, page: 1);
      setState(() {
        userList = users;
        page ++;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터를 불러오는 중 오류가 발생했습니다: $error')),
      );
    }
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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          showLottie = true;
        });
        _lottieController.repeat();
        final newUsers = await userService.getUserList(_searchController.text.trim(), page: page);
        print('page: $page, users: ${newUsers.toString()}');
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

  void onSearchChanged () {
    final query = _searchController.text.trim();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          isSearching = true;
          getUser = userService.getUserList(query, page: 1);
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

  void initializeIsPressedList(int length) {
    if (isPressedList.isEmpty) {
      isPressedList = List<bool>.filled(length, true);
    }
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
              padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  CustomSearchBar(
                    hintText: '사용자를 검색해보세요.',
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                  ),
                  SizedBox(height: 24.h),
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
                                future: userService.getUserCheck(userList[index].id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else {
                                    UserCheck userCheckData = snapshot.data!;
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
                                                      if (userCheckData.mutualCount == 0)
                                                        SizedBox(height: 14.h),
                                                      Text(
                                                        userCheckData.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bigHeadLine2
                                                            .copyWith(color: ColorSchemes.gray500),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Text(
                                                        userCheckData.userId,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .body2
                                                            .copyWith(color: ColorSchemes.gray300),
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      if (userCheckData.mutualCount > 0)
                                                        Text(
                                                          '함께하는 친구가 ${userCheckData.mutualCount}명 있습니다!',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .body3
                                                              .copyWith(color: ColorSchemes.gray200),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 37.w),
                                                CircleAvatar(
                                                  radius: StyleConstants.circleSizeL,
                                                  backgroundImage: NetworkImage(userCheckData.profileUrl),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 24.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: userCheckData.status == 'PENDING'
                                                  ? userCheckData.sourceId == selectedUser.id
                                                  ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 56.h,
                                                      child: CustomButton(
                                                        text: '친구 수락',
                                                        onPressed: () {
                                                          friendService.acceptFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                            Navigator.pop(context);
                                                          });
                                                        },
                                                        buttonColor: ColorSchemes.orange200,
                                                        textStyle: Theme.of(context).textTheme.smallHeadLine2,
                                                        textColor: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 56.h,
                                                      child: CustomButton(
                                                        text: '삭제',
                                                        onPressed: () {
                                                          friendService.deleteFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                            Navigator.pop(context);
                                                          });
                                                        },
                                                        buttonColor: ColorSchemes.gray100,
                                                        textStyle: Theme.of(context).textTheme.smallHeadLine2,
                                                        textColor: ColorSchemes.gray400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                                  : SizedBox(
                                                height: 56.h,
                                                child: CustomButton(
                                                  text: '요청 취소',
                                                  onPressed: () {
                                                    friendService.rejectFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  buttonColor: ColorSchemes.orange100,
                                                  textStyle: Theme.of(context).textTheme.smallHeadLine2,
                                                  textColor: Colors.white,
                                                ),
                                              )
                                                  : SizedBox(
                                                height: 56.h,
                                                child: CustomButton(
                                                  text: userCheckData.status == 'ACCEPTED'
                                                      ? '친구 삭제'
                                                      : userCheckData.status == 'PENDING'
                                                      ? (userCheckData.sourceId == selectedUser.id ? '친구 수락' : '삭제')
                                                      : '친구 요청',
                                                  onPressed: () {
                                                    switch (userCheckData.status) {
                                                      case 'ACCEPTED':
                                                        friendService.deleteFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                          Navigator.pop(context);
                                                        });
                                                        break;
                                                      case 'REJECTED':
                                                        friendService.rejectFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                          Navigator.pop(context);
                                                        });
                                                        break;
                                                      case 'NONE':
                                                        friendService.requestFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                          Navigator.pop(context);
                                                        });
                                                        break;
                                                      case 'PENDING':
                                                        if (userCheckData.sourceId == selectedUser.id) {
                                                          friendService.acceptFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                            Navigator.pop(context);
                                                          });
                                                        } else if (userCheckData.targetId == selectedUser.id) {
                                                          friendService.rejectFriend(Uuid(targetId: selectedUser.id)).then((_) {
                                                            Navigator.pop(context);
                                                          });
                                                        }
                                                        break;
                                                    }
                                                  },
                                                  buttonColor: ColorSchemes.orange200,
                                                  textStyle: Theme.of(context).textTheme.smallHeadLine2,
                                                  textColor: Colors.white,
                                                ),
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
                    } else if (index == userList.length && showLottie) {
                      return SizedBox(
                        height: 72.h,
                        child: Padding(
                          padding: EdgeInsets.only(top: 14.h, bottom: 26.h), // 위쪽 14, 아래쪽 26 간격
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      MaterialPageRoute(builder: (context) => AddFreindScreen()),
                    );
                  },
                  child: Text(
                    '전체보기',
                    style: Theme.of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.orange200),
                  ),
                ),
                SizedBox(width: 4.w),
              ],
            ),
            SizedBox(height: 24.h),
            FutureBuilder<List<FriendReqList>>(
              future: getReq,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: SizedBox(
                      height: 244.h,
                      child: Text(
                        '친구요청이 없습니다.',
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: ColorSchemes.gray300),
                      ),
                    ),
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
                          child: AddFriendProfile(
                            profileImage: friend.profileUrl,
                            userName: friend.name,
                            userId: friend.userId,
                            time: timeAgo(friend.createdAt, currentTime),
                            acceptOnPressed: () async {
                              await friendService.acceptFriend(Uuid(targetId: friend.id));
                              setState(() {
                                friendRequests.removeWhere((request) => request.id == friend.id);
                                friendSuggested.removeWhere((suggested) => suggested.id == friend.id);
                              });
                            },
                            rejectOnPressed: () async {
                              await friendService.rejectFriend(Uuid(targetId: friend.id));
                              setState(() {
                                friendRequests.removeWhere((request) => request.id == friend.id);
                              });
                            },
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
                  style: Theme.of(context)
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
                print('Snapshot data: ${snapshot.data}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      '추천된 친구가 없습니다.',
                      style: Theme.of(context).textTheme.body2.copyWith(color: ColorSchemes.gray300),
                    ),
                  );
                } else {
                  List<FriendSuggested> friendSuggested = snapshot.data!;
                  List<String> requestedUserIds = friendRequests.map((request) => request.id).toList();
                  List<FriendSuggested> filteredSuggestedFriends = friendSuggested
                      .where((friend) => !requestedUserIds.contains(friend.id))
                      .toList();
                  initializeIsPressedList(filteredSuggestedFriends.length);
                  return Column(
                    children: List.generate(
                      filteredSuggestedFriends.length,
                          (index) {
                        final friend = filteredSuggestedFriends[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == filteredSuggestedFriends.length - 1 ? 0 : 24.h,
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
                              final prefs = await SharedPreferences.getInstance();
                              List<String> delSugList = prefs.getStringList('delSugList') ?? [];
                              delSugList.add(friend.id);
                              await prefs.setStringList('delSugList', delSugList);
                              setState(() {
                                filteredSuggestedFriends.removeWhere((request) => request.id == friend.id);
                              });
                            },
                          ),
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
