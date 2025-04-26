import 'dart:async';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/friend_screen_skeleton.dart';
import 'package:modakbul/widgets/profile_bottom_sheet.dart';
import 'package:modakbul/widgets/user_list_profile.dart';

import '../../../widgets/global_error_widget.dart';

class FriendsTabScreen extends StatefulWidget {
  @override
  State<FriendsTabScreen> createState() => _FriendsTabScreenState();
}

class _FriendsTabScreenState extends State<FriendsTabScreen> {
  String selectedFilter = 'alphabetical';
  String filterText = '가나다순';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FriendService friendService = FriendService();
  UserService userService = UserService();
  List<FriendList> friendList = [];
  final FocusNode _searchFocusNode = FocusNode();
  late Future<List<FriendList>> getData;
  Timer? _debounce;
  ValueNotifier<List<FriendList>> _filteredFriendsNotifier = ValueNotifier([]);
  bool isLoading = false;
  bool _wasRefreshing = false;
  static const double _maxDragOffset = 36;

  @override
  void initState() {
    super.initState();
    getData = friendService.getFriendList();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _filteredFriendsNotifier.dispose();
    super.dispose();
  }

  List<FriendList> sortByName(List<FriendList> data) {
    data.sort((a, b) => a.userName.compareTo(b.userName));
    return data;
  }

  List<FriendList> sortByRecent(List<FriendList> data) {
    data.sort((a, b) {
      DateTime dateA = DateTime.parse(a.updatedAt!);
      DateTime dateB = DateTime.parse(b.updatedAt!);
      return dateB.compareTo(dateA);
    });
    return data;
  }

  List<FriendList> sortByCount(List<FriendList> data) {
    data.sort((a, b) => b.count.compareTo(a.count));
    return data;
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterFriends();
    });
  }

  void _filterFriends() {
    String searchQuery = _searchController.text.toLowerCase().trim();
    List<FriendList> filtered = friendList.where((friend) {
      return friend.userName.toLowerCase().contains(searchQuery) ||
          friend.userId.toLowerCase().contains(searchQuery);
    }).toList();
    _filteredFriendsNotifier.value = filtered;
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    getData = friendService.getFriendList();
    _filteredFriendsNotifier.value = [];

    setState(() {
      isLoading = false;
    });
  }

  String? _getLoadingAsset(double offset) {
    if (offset < 0.1) return null;
    int segment = ((offset / _maxDragOffset) * 8).floor() + 1;
    segment = segment.clamp(1, 8);

    switch (segment) {
      case 1:
        return AnimationPath.loading1;
      case 2:
        return AnimationPath.loading2;
      case 3:
        return AnimationPath.loading3;
      case 4:
        return AnimationPath.loading4;
      case 5:
        return AnimationPath.loading5;
      case 6:
        return AnimationPath.loading6;
      case 7:
        return AnimationPath.loading7;
      case 8:
        return AnimationPath.loading8;
      default:
        return AnimationPath.loading1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: SafeArea(
        child: CustomRefreshIndicator(
          triggerMode: IndicatorTriggerMode.onEdge,
          offsetToArmed: _maxDragOffset,
          onRefresh: _refreshData,
          builder: (BuildContext context, Widget child,
              IndicatorController controller) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!controller.isIdle)
                  Positioned(
                    top: 10.h,
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: Center(
                        child: controller.isLoading
                            ? Lottie.asset(
                                width: 25.r,
                                height: 25.r,
                                AnimationPath.loadingFeed,
                                animate: controller.isLoading,
                              )
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return child;
                                },
                                child: _getLoadingAsset(controller.value *
                                            _maxDragOffset) !=
                                        null
                                    ? SvgPicture.asset(
                                        _getLoadingAsset(
                                            controller.value * _maxDragOffset)!,
                                        width: 25.r,
                                        height: 25.r,
                                        key: ValueKey<String>(_getLoadingAsset(
                                            controller.value *
                                                _maxDragOffset)!),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                      ),
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0, _maxDragOffset * controller.value),
                  child: child,
                ),
              ],
            );
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: StyleConstants.defaultPadding),
                    child: FutureBuilder<List<FriendList>>(
                      future: getData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const FriendScreenSkeleton();
                        } else if (snapshot.hasError) {
                          return const GlobalErrorWidget();
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return _buildEmptyFriendList();
                        } else {
                          friendList = snapshot.data!;
                          _filteredFriendsNotifier.value = friendList;
                          return _buildFriendList();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFriendList() {
    return Column(
      children: [
        SizedBox(height: 10.h),
        CustomSearchBar(
          hintText: '사용자를 검색해보세요.',
          controller: _searchController,
          focusNode: _searchFocusNode,
        ),
        SizedBox(height: 144.h),
        Center(
          child: Column(
            children: [
              Text('아직 친구가 없습니다',
                  style: Theme.of(context)
                      .textTheme
                      .bigHeadLine3
                      .copyWith(color: ColorSchemes.orange100)),
              SizedBox(height: 8.h),
              Text('친구를 추가하고 모닥불을 피워보세요.',
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: ColorSchemes.gray300)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFriendList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        CustomSearchBar(
          hintText: '사용자를 검색해보세요.',
          controller: _searchController,
          focusNode: _searchFocusNode,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            SizedBox(width: 4.w),
            Text(filterText,
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine4
                    .copyWith(color: ColorSchemes.gray500)),
            Spacer(),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildFilterBottomSheet(),
                );
              },
              child: Text('필터',
                  style: Theme.of(context)
                      .textTheme
                      .body3
                      .copyWith(color: ColorSchemes.gray300)),
            ),
            SizedBox(width: 4.w),
          ],
        ),
        SizedBox(height: 14.h),
        ValueListenableBuilder<List<FriendList>>(
          valueListenable: _filteredFriendsNotifier,
          builder: (context, filteredFriends, _) {
            if (filteredFriends.isEmpty) {
              return Column(
                children: [
                  SizedBox(height: 144.h),
                  Text('검색 결과가 없습니다',
                      style: Theme.of(context)
                          .textTheme
                          .bigHeadLine3
                          .copyWith(color: ColorSchemes.orange100)),
                  SizedBox(height: 8.h),
                  Text('검색어를 다시 확인해 주세요.',
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: ColorSchemes.gray300)),
                ],
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return FutureBuilder<UserCheck>(
                          future: userService.getUserCheck(friend.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(height: 304.h);
                            } else if (snapshot.hasError) {
                              return SizedBox(height: 304.h);
                            } else {
                              UserCheck userCheckData = snapshot.data!;
                              return ProfileBottomSheet(
                                userCheckData: userCheckData,
                                selectedUserId: friend.id,
                                friendService: friendService,
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  child: UserListProfile(
                    userName: friend.userName,
                    userId: friend.userId,
                    profileImage: friend.profileUrl,
                    onIconPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        enableDrag: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(StyleConstants.radiusLarge),
                                topRight:
                                    Radius.circular(StyleConstants.radiusLarge),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: StyleConstants.defaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 38.h),
                                  Text(friend.userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bigHeadLine3
                                          .copyWith(
                                              color: ColorSchemes.gray500)),
                                  SizedBox(height: 24.h),
                                  InkWell(
                                    overlayColor: WidgetStateProperty.all(
                                        Colors.transparent),
                                    onTap: () async {
                                      await friendService.deleteFriend(
                                          Uuid(targetId: friend.id));
                                      setState(() {
                                        friendList.removeWhere(
                                            (item) => item.id == friend.id);
                                        _filteredFriendsNotifier.value =
                                            List.from(friendList);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('삭제하기',
                                            style: Theme.of(context)
                                                .textTheme
                                                .smallHeadLine2
                                                .copyWith(
                                                    color:
                                                        ColorSchemes.gray300)),
                                        SizedBox(
                                          width: 24.r,
                                          height: 24.r,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              IconPath.arrowForwardGray200,
                                              width: 9.r,
                                              height: 16.r,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  InkWell(
                                    overlayColor: WidgetStateProperty.all(
                                        Colors.transparent),
                                    onTap: () async {
                                      await friendService.blockFriend(
                                          Uuid(targetId: friend.id));
                                      setState(() {
                                        friendList.removeWhere(
                                            (item) => item.id == friend.id);
                                        _filteredFriendsNotifier.value =
                                            List.from(friendList);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('차단하기',
                                            style: Theme.of(context)
                                                .textTheme
                                                .smallHeadLine2
                                                .copyWith(
                                                    color:
                                                        ColorSchemes.gray300)),
                                        SizedBox(
                                          width: 24.r,
                                          height: 24.r,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              IconPath.arrowForwardGray200,
                                              width: 9.r,
                                              height: 16.r,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 56.h),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(StyleConstants.radiusLarge),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 38.h),
            Row(
              children: [
                Text('정렬',
                    style: Theme.of(context)
                        .textTheme
                        .bigHeadLine3
                        .copyWith(color: ColorSchemes.gray500)),
              ],
            ),
            SizedBox(height: 24.h),
            _buildFilterOption('가나다순', 'alphabetical'),
            SizedBox(height: 24.h),
            _buildFilterOption('최신순', 'latest'),
            SizedBox(height: 24.h),
            _buildFilterOption('자주 만나는 친구', 'frequent'),
            SizedBox(height: 56.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, String filterKey) {
    bool isSelected = selectedFilter == filterKey;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: ColorSchemes.white),
        onPressed: () {
          setState(() {
            selectedFilter = filterKey;
            filterText = title;
            switch (filterKey) {
              case 'alphabetical':
                _filteredFriendsNotifier.value = sortByName(friendList);
                break;
              case 'latest':
                _filteredFriendsNotifier.value = sortByRecent(friendList);
                break;
              case 'frequent':
                _filteredFriendsNotifier.value = sortByCount(friendList);
                break;
            }
          });
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.body2.copyWith(
                    color: isSelected
                        ? ColorSchemes.orange200
                        : ColorSchemes.gray300)),
            if (isSelected)
              SizedBox(
                height: 24.r,
                width: 24.r,
                child: SvgPicture.asset(
                  IconPath.check,
                  width: 20.r,
                  fit: BoxFit.scaleDown,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
