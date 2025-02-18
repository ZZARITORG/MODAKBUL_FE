import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/group_list.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/services/group_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';


class GroupEditScreen extends StatefulWidget {
  const GroupEditScreen({super.key});

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

///TODO SingleTickerProviderStateMixin 공부
class _GroupEditScreenState extends State<GroupEditScreen> {
  String selectedFilter = 'latest';
  String filterText = '자주 만나는 친구';
  List<Map<String, String>> selectedFriends = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FriendService friendService = FriendService();
  List<FriendList> friendList = [];
  late Future<List<FriendList>> getData;
  final GroupService _groupService = GroupService();
  final FocusNode _searchFocusNode = FocusNode();
  String updateGroupName = '';
  bool get isButtonEnabled => selectedFriends.length >= 2;

  ValueNotifier<List<FriendList>> _filteredFriendsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFriends);

    // friendList를 초기화하거나 필터링된 데이터를 설정
    getData = friendService.getFriendList(); // 친구 데이터를 불러오는 Future
    getData.then((data) {
      setState(() {
        friendList = data; // 전체 친구 리스트 저장
        _filteredFriendsNotifier.value = data; // 초기 필터링된 리스트 설정

        // 이미 그룹 멤버인 친구들에 대해 _toggleSelectGroup 호출하여 선택 상태로 만듦
        final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final List<Member> members = args['members'];
        print('Members List: ${members}');
        for (var member in members) {
          final userId = member.user.id;
          final userName = member.user.name;
          final profileUrl = member.user.profileUrl;
            _toggleSelectGroup(userId, userName, profileUrl);
          }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

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

  void _toggleSelectGroup(
      String userId, String userName, String profilePicture) {
    setState(() {
      final friend = {
        'userId': userId,
        'userName': userName,
        'profilePicture': profilePicture,
      };
      /// 이미 선택된 친구인지 확인하여 추가 또는 제거
      if (selectedFriends.any((friend) => friend['userId'] == userId)) {
        selectedFriends.removeWhere((friend) => friend['userId'] == userId);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  ///TODO 디바운딩 추가, TODO 검색방식 정하기
  void _filterFriends() {
    String searchQuery = _searchController.text.toLowerCase().trim();
    List<FriendList> filtered = friendList.where((friend) {
      return friend.userName.toLowerCase().contains(searchQuery) ||
          friend.userId.toLowerCase().contains(searchQuery);
    }).toList();
    _filteredFriendsNotifier.value = filtered;
  }
  void _updateGroup() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String groupName = args['groupName'];
    final String groupId = args['groupId'];
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('그룹 이름을 입력해주세요.')),
      );
      return;
    }

    List<String> friendIds = selectedFriends.map((friend) => friend['userId']!).toList();

    if (friendIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('친구를 선택해주세요.')),
      );
      return;
    }
    // updateGroupname이 있으면 그 값을, 없으면 groupName을 보냄
    final String finalGroupName = updateGroupName.isNotEmpty ? updateGroupName : groupName;
    try {
      final response = await _groupService.updateGroup(groupId, finalGroupName, friendIds);
      print('그룹 수정 성공: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('그룹 성공적으로 수정!')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      print('그룹 수정 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('그룹 수정에 실패.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // `arguments`로 전달된 데이터 받기
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String groupName = args['groupName'];
    final String groupId = args['groupId'];
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar.actions(
        backgroundColor: ColorSchemes.gray000,
        onActionPressed: () {},
      ),
      body: /*Skeleton 들어갈 자리 */ SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: StyleConstants.defaultPadding),
                  child: FutureBuilder<List<FriendList>>(
                      future: getData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('데이터 로드 중 오류 발생'));
                        }
                        friendList = snapshot.data ?? [];
                        _filteredFriendsNotifier.value = friendList;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  updateGroupName = value;
                                });
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: ColorSchemes.gray500),
                              cursorColor: ColorSchemes.orange100,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                counterText: '',
                                suffixIcon: SizedBox(
                                  height: 32.r,
                                  width: 32.r,
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 2.w),
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      IconPath.edit,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  minWidth: 0.w,
                                  minHeight: 0.h,
                                ),
                                hintText: groupName,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .smallHeadLine1
                                    .copyWith(color: ColorSchemes.gray200),
                                isDense: true,
                                contentPadding:
                                EdgeInsets.only(left: 4.w, bottom: 4.h),
                                border: InputBorder.none,
                                errorText: null,
                                errorStyle: const TextStyle(
                                    color: ColorSchemes.orange100, fontSize: 0),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              height: 2.w,
                              decoration: BoxDecoration(
                                color: ColorSchemes.gray100,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      if (selectedFriends.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: StyleConstants.defaultPadding, right: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: selectedFriends.map((friend) {
                              return Padding(
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
                              );
                            }).toList(),
                          ),
                        ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: StyleConstants.defaultPadding),
                        child: Column(
                          children: [
                            CustomSearchBar(
                              hintText: '친구를 검색해보세요.',
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: StyleConstants.defaultPadding),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                ValueListenableBuilder<List<FriendList>>(
                                    valueListenable: _filteredFriendsNotifier,
                                    builder: (context, filteredFriends, _) {
                                      if (filteredFriends.isEmpty) {
                                        return Center(
                                          // Wrap the Column with Center widget
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            // Vertically center content
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            // Horizontally center content
                                            children: [
                                              SizedBox(height: 144.h),
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
                                                    color: ColorSchemes
                                                        .gray300),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  filterText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bigHeadLine4
                                                      .copyWith(
                                                      color: ColorSchemes
                                                          .gray500),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                      context) {
                                                        return Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                            BorderRadius
                                                                .only(
                                                              topLeft: Radius.circular(
                                                                  StyleConstants
                                                                      .radiusLarge),
                                                              topRight: Radius.circular(
                                                                  StyleConstants
                                                                      .radiusLarge),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                StyleConstants
                                                                    .defaultPadding),
                                                            child: Column(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                    38.h),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      '정렬',
                                                                      style: Theme.of(
                                                                          context)
                                                                          .textTheme
                                                                          .bigHeadLine3
                                                                          .copyWith(
                                                                          color: ColorSchemes.gray500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 24.h),
                                                                _buildFilterOption(
                                                                    '최신순',
                                                                    'latest',
                                                                    context),
                                                                SizedBox(height: 24.h),
                                                                _buildFilterOption(
                                                                    '가나다순',
                                                                    'alphabetical',
                                                                    context),
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
                                                  child: Text('정렬',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .body3
                                                        .copyWith(
                                                        color: ColorSchemes
                                                            .gray300),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 14.h),
                                            ValueListenableBuilder<List<FriendList>>(
                                              valueListenable:
                                              _filteredFriendsNotifier,
                                              builder: (context,
                                                  filteredFriends, _) {
                                                return ListView.builder(
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                  filteredFriends.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                      int index) {
                                                    final friend = filteredFriends[index];
                                                    final isChecked = selectedFriends.any(
                                                          (selectedFriend) =>
                                                      selectedFriend['userId'] == friend.id,
                                                    );
                                                    return GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () {
                                                        _toggleSelectGroup(
                                                            friend.id,
                                                            friend.userName,
                                                            friend.profileUrl);
                                                        _searchController.text = ''; // 검색어 초기화
                                                      },
                                                      child:
                                                      SelectUserListProfile(
                                                        userName:
                                                        friend.userName,
                                                        userId: friend.userId,
                                                        profileImage:
                                                        friend.profileUrl,
                                                        isChecked: isChecked,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                                SizedBox(height: 88.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
                      child: CustomButton(
                          text: '그룹 수정하기',
                          onPressed: isButtonEnabled ? _updateGroup : null,
                          buttonColor:
                          ColorSchemes.orange200,
                          textStyle: Theme.of(context)
                              .textTheme
                              .smallHeadLine2,
                          textColor:
                          ColorSchemes.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

mixin groupName {
}