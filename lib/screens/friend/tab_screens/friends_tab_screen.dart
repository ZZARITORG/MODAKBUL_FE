import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/friend_screen_skeleton.dart';
import 'package:modakbul/widgets/user_list_profile.dart';

///TODO 검색방식 생각, 키보드 내리는것도 생각(탭바 안쓸수도있음), 리스트 끝까지올렸을때 마진 고려
class FriendsTabScreen extends StatefulWidget {
  const FriendsTabScreen({super.key});

  @override
  State<FriendsTabScreen> createState() => _FriendsTabScreenState();
}

class _FriendsTabScreenState extends State<FriendsTabScreen> {
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

  // ValueNotifier로 _filteredFriends 관리
  ValueNotifier<List<FriendList>> _filteredFriendsNotifier = ValueNotifier([]);

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                child: FutureBuilder<List<FriendList>>(
                    future: getData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const FriendScreenSkeleton();
                      } else if (snapshot.hasError) {
                        return Text('에라떳다!!!!!!!!!!!');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('데이타가 없음 ㅜㅜ');
                      } else {
                        friendList = snapshot.data!;
                        _filteredFriendsNotifier.value = friendList;
                        return Column(
                          children: [
                            CustomSearchBar(
                              hintText: '사용자를 검색해보세요.',
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                            ),
                            SizedBox(height: 24.h),
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
                                                _buildFilterOption('가나다순', 'alphabetical', context),
                                                SizedBox(height: 24.h),
                                                _buildFilterOption('최신순', 'latest', context),
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
                                    '필터',
                                    style: Theme.of(context).textTheme.body3.copyWith(color: ColorSchemes.gray300),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            ValueListenableBuilder<List<FriendList>>(
                              valueListenable: _filteredFriendsNotifier,
                              builder: (context, filteredFriends, _) {
                                if (filteredFriends.isEmpty) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 132.h),
                                      Text(
                                        '검색결과가 없습니다',
                                        style: Theme.of(context).textTheme.bigHeadLine3.copyWith(color: ColorSchemes.orange100),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        '검색어를 다시 확인해 주세요',
                                        style: Theme.of(context).textTheme.body2.copyWith(color: ColorSchemes.gray300),
                                      ),
                                    ],
                                  );
                                }
                                return ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: filteredFriends.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String id = filteredFriends[index].id;
                                    String profileUrl = filteredFriends[index].profileUrl;
                                    String userName = filteredFriends[index].userName;
                                    String userId = filteredFriends[index].userId;
                                    return UserListProfile(
                                      userName: userName,
                                      userId: userId,
                                      profileImage: profileUrl,
                                      onIconPressed: () {
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(height: 38.h),
                                                      Text(userName, style: Theme.of(context).textTheme.bigHeadLine3.copyWith(color: ColorSchemes.gray500)),
                                                      SizedBox(height: 24.h),
                                                      InkWell(
                                                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                                                        onTap: () async {
                                                         await friendService.deleteFriend(Uuid(targetId: id));
                                                         setState(() {
                                                           // friendList에서 해당 친구 삭제
                                                           friendList.removeWhere((friend) => friend.id == id);
                                                           // 검색 결과에서도 삭제
                                                           _filteredFriendsNotifier.value = List.from(friendList);
                                                         });
                                                         Navigator.pop(context);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('삭제하기', style: Theme.of(context).textTheme.smallHeadLine2.copyWith(color: ColorSchemes.gray300)),
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
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 24.h),
                                                      InkWell(
                                                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                                                        onTap: () async {
                                                          await friendService.blockFriend(Uuid(targetId: id));
                                                          setState(() {
                                                            // friendList에서 해당 친구 삭제
                                                            friendList.removeWhere((friend) => friend.id == id);
                                                            // 검색 결과에서도 삭제
                                                            _filteredFriendsNotifier.value = List.from(friendList);
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('차단하기', style: Theme.of(context).textTheme.smallHeadLine2.copyWith(color: ColorSchemes.gray300)),
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
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 56.h),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOption(String title, String filterKey, BuildContext context) {
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
                color: isSelected ? ColorSchemes.orange200 : ColorSchemes.gray300,
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
