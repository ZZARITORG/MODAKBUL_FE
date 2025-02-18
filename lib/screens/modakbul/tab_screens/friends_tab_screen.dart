import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/providers/meeting_provider.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/friend_screen_skeleton.dart';
import 'package:modakbul/widgets/global_error_widget.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:provider/provider.dart';

///TODO 검색방식 생각,
class FriendsTabScreen extends StatefulWidget {
  const FriendsTabScreen({super.key});

  @override
  State<FriendsTabScreen> createState() => _FriendsTabScreenState();
}

class _FriendsTabScreenState extends State<FriendsTabScreen> {
  List<Map<String, String>> selectedFriends = [];
  String selectedFilter = 'alphabetical';
  String filterText = '가나다순';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FriendService friendService = FriendService();
  List<FriendList> friendList = [];
  final FocusNode _searchFocusNode = FocusNode();
  late Future<List<FriendList>> getData;
  Timer? _debounce;
  Logger logger = Logger(printer: PrettyPrinter());
  late MeetingProvider meetingProvider;

  // ValueNotifier로 _filteredFriends 관리
  ValueNotifier<List<FriendList>> _filteredFriendsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    getData = friendService.getFriendList();
    _searchController.addListener(_onSearchChanged);
    meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
    selectedFriends = meetingProvider.selectFriends ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _filteredFriendsNotifier.dispose();
    super.dispose();
  }

  // 가나다순 정렬 함수
  List<FriendList> sortByName(List<FriendList> data) {
    // userName을 기준으로 오름차순 정렬
    data.sort((a, b) => a.userName.compareTo(b.userName));
    return data;
  }

// 최신순 정렬 함수 (최신 날짜가 먼저)
  List<FriendList> sortByRecent(List<FriendList> data) {
    data.sort((a, b) {
      // updatedAt을 기준으로 내림차순 정렬 (최신순)
      DateTime dateA = DateTime.parse(a.updatedAt!);
      DateTime dateB = DateTime.parse(b.updatedAt!);
      return dateB.compareTo(dateA); // 최신순 정렬
    });
    return data;
  }

// 자주 만나는 순 정렬 함수 (count 높은 순)
  List<FriendList> sortByCount(List<FriendList> data) {
    data.sort((a, b) {
      // count 값을 기준으로 내림차순 정렬 (높은 순)
      return b.count.compareTo(a.count);
    });
    return data;
  }

  // 검색 입력이 변경될 때마다 실행되는 함수
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterFriends();
    });
  }

  // 검색 필터링 함수
  void _filterFriends() {
    String searchQuery = _searchController.text.toLowerCase().trim();
    List<FriendList> filtered = friendList.where((friend) {
      return friend.userName.toLowerCase().contains(searchQuery) ||
          friend.userId.toLowerCase().contains(searchQuery);
    }).toList();
    _filteredFriendsNotifier.value = filtered;
  }

  void _toggleSelectGroup(
      String userId, String userName, String profilePicture, String id) {
    setState(() {
      final friend = {
        'userId': userId,
        'userName': userName,
        'profilePicture': profilePicture,
        'id': id,
      };

      /// 이미 선택된 친구인지 확인하여 추가 또는 제거
      if (selectedFriends.any((friend) => friend['userId'] == userId)) {
        selectedFriends.removeWhere((friend) => friend['userId'] == userId);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                CustomSearchBar(
                  hintText: '친구를 검색해 보세요.',
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Builder(builder: (context) {
                  if (selectedFriends.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(
                          left: StyleConstants.defaultPadding,
                          right: 4.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: selectedFriends.map((friend) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: StyleConstants.circleSizeM,
                                            child: ClipOval(
                                                child: CachedNetworkImage(imageUrl: friend['profilePicture']!)),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: SizedBox(
                                              height: 24.r,
                                              width: 24.r,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedFriends.removeWhere(
                                                      (item) =>
                                                          item['userId'] ==
                                                          friend['userId'],
                                                    );
                                                  });
                                                },
                                                icon: SvgPicture.asset(
                                                  IconPath.cancel,
                                                  width: 24.r,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      SizedBox(
                                        width: StyleConstants.circleSizeM * 2,
                                        child: Center(
                                          child: Text(
                                            friend['userName']!,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body3
                                                .copyWith(
                                                    color: ColorSchemes.gray300),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                }),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: StyleConstants.defaultPadding),
                  child: FutureBuilder<List<FriendList>>(
                      future: getData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const FriendScreenSkeleton();
                        } else if (snapshot.hasError) {
                          return const GlobalErrorWidget();
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(height: 14.h),
                              Row(
                                children: [
                                  Text(
                                    filterText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bigHeadLine4
                                        .copyWith(color: ColorSchemes.gray500),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(StyleConstants.radiusLarge),
                                                topRight: Radius.circular(StyleConstants.radiusLarge),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: 38.h),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '필터',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bigHeadLine3
                                                            .copyWith(color: ColorSchemes.gray500),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 24.h),
                                                  _buildFilterOption('최신순', 'latest', context),
                                                  SizedBox(height: 24.h),
                                                  _buildFilterOption('가나다순', 'alphabetical', context),
                                                  SizedBox(height: 24.h),
                                                  _buildFilterOption('자주 만나는 친구', 'frequent', context),
                                                  SizedBox(height: 56.h),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      '정렬',
                                      style: Theme.of(context).textTheme.body3.copyWith(color: ColorSchemes.gray300),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 144.h,
                              ),
                              Text(
                                '아직 친구가 없습니다',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine3
                                    .copyWith(color: ColorSchemes.orange100),
                              ),
                              SizedBox(height: 8.h,),
                              Text(
                                '친구를 추가하고 모닥불을 피워보세요.',
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(color: ColorSchemes.gray300),
                              )
                            ],
                          );
                        } else {
                          friendList = snapshot.data!;
                          _filteredFriendsNotifier.value = friendList;
                          return Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        filterText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bigHeadLine4
                                            .copyWith(
                                                color: ColorSchemes.gray500),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          StyleConstants
                                                              .radiusLarge),
                                                      topRight: Radius.circular(
                                                          StyleConstants
                                                              .radiusLarge),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: StyleConstants
                                                            .defaultPadding),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(height: 38.h),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '정렬',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bigHeadLine3
                                                                  .copyWith(
                                                                      color: ColorSchemes
                                                                          .gray500),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 24.h),
                                                        _buildFilterOption(
                                                            '가나다순',
                                                            'alphabetical',
                                                            context),
                                                        SizedBox(height: 24.h),
                                                        _buildFilterOption('최신순',
                                                            'latest', context),
                                                        SizedBox(height: 24.h),
                                                        _buildFilterOption(
                                                            '자주 만나는 친구',
                                                            'frequent',
                                                            context),
                                                        SizedBox(height: 56.h),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            '필터',
                                            style: Theme.of(context)
                                                .textTheme
                                                .body3
                                                .copyWith(
                                                    color: ColorSchemes.gray300),
                                          )),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  ValueListenableBuilder<List<FriendList>>(
                                      valueListenable: _filteredFriendsNotifier,
                                      builder: (context, filteredFriends, _) {
                                        if (filteredFriends.isEmpty) {
                                          return Column(
                                            children: [
                                              SizedBox(height: 132.h),
                                              Text(
                                                '검색결과가 없습니다',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bigHeadLine3
                                                    .copyWith(
                                                        color: ColorSchemes
                                                            .orange100),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                '검색어를 다시 확인해 주세요',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body2
                                                    .copyWith(
                                                        color:
                                                            ColorSchemes.gray300),
                                              ),
                                            ],
                                          );
                                        }
                                        return ListView.builder(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: filteredFriends.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final friend =
                                                  filteredFriends[index];
                                              final isChecked = selectedFriends
                                                  .any((selectedFriend) =>
                                                      selectedFriend['userId'] ==
                                                      friend.userId);
                                              return GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                /*overlayColor: const WidgetStatePropertyAll(
                                        Colors.transparent,

                                        ///투명으로 바꿀수도있음
                                                                        ),*/
                                                onTap: () {
                                                  _toggleSelectGroup(
                                                      friend.userId,
                                                      friend.userName,
                                                      friend.profileUrl,
                                                      friend.id);
                                                  //filteredFriends = snapshot.data!;
                                                  _searchController.text = '';
                                                },
                                                onTapDown: (_) {
                                                  /// 터치 이벤트가 상위로 전파되는 것을 막습니다
                                                  /// 이렇게 하면 SelectUserListProfile을 터치해도 키보드가 내려가지 않습니다
                                                },
                                                child: SelectUserListProfile(
                                                  userName: filteredFriends[index]
                                                      .userName,
                                                  userId: filteredFriends[index]
                                                      .userId,
                                                  profileImage:
                                                      filteredFriends[index]
                                                          .profileUrl,
                                                  isChecked: isChecked,
                                                ),
                                              );
                                            });
                                      }),
                                ],
                              ),
                              SizedBox(height: 88.h),
                            ],
                          );
                        }
                      }),
                )
              ],
            ),
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
                          text: '그룹 선택',
                          onPressed: selectedFriends.length >= 2
                              ? () {
                                  meetingProvider.selectGroupName =
                                      '${selectedFriends[0]['userName']} 외 ${selectedFriends.length - 1}명';
                                  meetingProvider.selectFriends = selectedFriends;
                                  meetingProvider.isGroup = false;
                                  Navigator.pop(context);
                                }
                              : null,
                          buttonColor: ColorSchemes.orange200,
                          textStyle: Theme.of(context).textTheme.smallHeadLine2,
                          textColor: ColorSchemes.white),
                    )),
              ],
            ))
      ],
    );
  }

  Widget _buildFilterOption(
      String title, String filterKey, BuildContext context) {
    bool isSelected = selectedFilter == filterKey;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: ColorSchemes.white),
        onPressed: () {
          setState(() {
            selectedFilter = isSelected ? '' : filterKey;
            switch (filterKey) {
              case 'latest':
                filterText = '최신순';
                _filteredFriendsNotifier.value = sortByRecent(friendList);
                break;
              case 'alphabetical':
                filterText = '가나다순';
                _filteredFriendsNotifier.value = sortByName(friendList);
                break;
              case 'frequent':
                filterText = '자주 만나는 친구';
                _filteredFriendsNotifier.value = sortByCount(friendList);
                break;
            }
          });
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.body2.copyWith(
                    color: isSelected
                        ? ColorSchemes.orange200
                        : ColorSchemes.gray300,
                  ),
            ),
            SizedBox(
              height: 24.r,
              width: 24.r,
              child: isSelected
                  ? SvgPicture.asset(
                      IconPath.check,
                      width: 20.r,
                      fit: BoxFit.scaleDown,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
