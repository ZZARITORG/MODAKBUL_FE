import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/group_list.dart';
import 'package:modakbul/screens/friend/create_group_screen.dart';
import 'package:modakbul/screens/friend/group_edit_screen.dart';
import 'package:modakbul/services/group_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/group_list_tile.dart';
import 'package:modakbul/widgets/group_screen_skeleton.dart';


class GroupsTabScreen extends StatefulWidget {
  const GroupsTabScreen({super.key});

  @override
  State<GroupsTabScreen> createState() => _GroupsTabScreenState();
}

class _GroupsTabScreenState extends State<GroupsTabScreen> {
  String selectedFilter = 'latest';
  String filterText = '최신순';
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController = ScrollController();
  GroupService groupService = GroupService();
  List<Group> groupList = [];
  final FocusNode _searchFocusNode = FocusNode();
  late Future<List<Group>> getData;
  late DateTime currentTime;
  bool _showLottie = false;
  bool _isRefreshing = false;
  Timer? _debounce;
  Logger logger = Logger(printer: PrettyPrinter());

  // ValueNotifier로 _filteredGroups 관리
  final ValueNotifier<List<Group>> _filteredGroupsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    getData = groupService.getGroupList();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_scrollListener);
}

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    _filteredGroupsNotifier.dispose();
    super.dispose();
  }

  // 가나다순 정렬 함수
  List<Group> sortByName(List<Group> data) {
    data.sort((a, b) => a.name.compareTo(b.name));
    return data;
  }
  void _reloadGroups() {
    setState(() {
      // 그룹 목록을 다시 가져옵니다.
      getData = groupService.getGroupList(); // 새로운 데이터 로드
    });
  }
  void _onGroupEdit() {
    // 그룹 수정 화면에서 돌아오면서 데이터 새로고침
    _reloadGroups(); // 새로운 데이터를 로드
    Navigator.pop(context); // 이전 화면으로 돌아감
  }

  /*void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
      setState(() {
        _showLottie = isBottom;
      });
    } else {
      setState(() {
        _showLottie = false;
      });
    }
  }*/

  // 최신순 정렬 함수 (최신 날짜가 먼저)
  List<Group> sortByRecent(List<Group> data) {
    data.sort((a, b) {
      DateTime dateA = DateTime.parse(a.updatedAt!);
      DateTime dateB = DateTime.parse(b.updatedAt!);
      return dateB.compareTo(dateA); // 최신순 정렬
    });
    return data;
  }

  // 자주 만나는 그룹 순 정렬 함수 (count 높은 순)
  List<Group> sortByCount(List<Group> data) {
    data.sort((a, b) {
      return b.count.compareTo(a.count); // 내림차순 정렬
    });
    return data;
  }

  // 검색 입력이 변경될 때마다 실행되는 함수
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterGroups();
    });
  }

  // 검색 필터링 함수
  void _filterGroups() {
    String searchQuery = _searchController.text.toLowerCase().trim();
    List<Group> filtered = groupList.where((group) {
      return group.name.toLowerCase().contains(searchQuery) ||
          group.id.toLowerCase().contains(searchQuery);
    }).toList();
    _filteredGroupsNotifier.value = filtered;
  }

  static String timeAgo(DateTime dateTime, DateTime currentTime) {
    Duration difference = currentTime.difference(dateTime); // 시간 차이 계산

    if (difference.inDays > 0) {
      // 하루 이상 차이 나면 "몇 일 전" 형태로 출력
      return '${difference.inDays}일 전 모닥불을 피웠습니다!';
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

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isRefreshing) {
        setState(() {
          _isRefreshing = true;
          _showLottie = true; // 로티 애니메이션 표시
        });
        _refreshData();
      }
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2)); // 데이터 새로고침 로직
    setState(() {
      _isRefreshing = false;
      _showLottie = false; // 로딩 애니메이션 종료
    });
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
                child: FutureBuilder<List<Group>>(
                    future: getData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const GroupScreenSkeleton();
                      } else if (snapshot.hasError) {
                        return Text('에러 발생');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('데이터 없음');
                      } else {
                        groupList = snapshot.data!;
                        _filteredGroupsNotifier.value = groupList;
                        return Column(
                          children: [
                            CustomSearchBar(
                              hintText: '그룹을 검색해보세요.',
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
                                                _buildFilterOption('최신순', 'latest', context),
                                                SizedBox(height: 24.h),
                                                _buildFilterOption('가나다순', 'alphabetical', context),
                                                SizedBox(height: 24.h),
                                                _buildFilterOption('자주 만나는 그룹', 'frequent', context),
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateGroupScreen()),
                                ).then((_) {
                                  // GroupEditScreen에서 돌아오면 데이터를 새로 고침
                                  _reloadGroups(); // 그룹 데이터를 갱신
                                });
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CreateGroupScreen()),
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(StyleConstants.radiusMedium),
                                    ),
                                    color: ColorSchemes.gray100,
                                    margin: EdgeInsets.zero,
                                    elevation: 0,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.h, bottom: 14.h),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 98.r,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  child: CircleAvatar(
                                                    radius: StyleConstants.circleSizeXS,
                                                    backgroundColor: ColorSchemes.white,
                                                    child: CircleAvatar(
                                                      radius: StyleConstants.circleSizeXXXS,
                                                      backgroundColor: ColorSchemes.orange200,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 28.r,
                                                  child: CircleAvatar(
                                                    radius: StyleConstants.circleSizeXS,
                                                    backgroundColor: ColorSchemes.white,
                                                    child: CircleAvatar(
                                                      radius: StyleConstants.circleSizeXXXS,
                                                      backgroundColor: ColorSchemes.orange100,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 56.r,
                                                  child: CircleAvatar(
                                                    radius: StyleConstants.circleSizeXS,
                                                    backgroundColor: ColorSchemes.white,
                                                    child: CircleAvatar(
                                                      radius: StyleConstants.circleSizeXXXS,
                                                      backgroundColor: ColorSchemes.gray300,
                                                      child: SvgPicture.asset(IconPath.plus, width: 11.r),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            '그룹 생성하기',
                                            style: Theme.of(context)
                                                .textTheme
                                                .smallHeadLine3
                                                .copyWith(color: ColorSchemes.gray200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            // 필터링된 데이터 표시
                            ValueListenableBuilder<List<Group>>(
                              valueListenable: _filteredGroupsNotifier,
                              builder: (context, filteredGroups, _) {
                                if (filteredGroups.isEmpty) {
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
                                  itemCount: filteredGroups.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String groupName = filteredGroups[index].name;
                                    String groupId = filteredGroups[index].id;
                                    var members = filteredGroups[index].members;
                                    String profileImage2 = members.length > 1 ? members[1].user.profileUrl : '';
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GroupEditScreen(),
                                            settings: RouteSettings(
                                              arguments: {
                                                'groupId': filteredGroups[index].id,
                                                'groupName': filteredGroups[index].name,  // 그룹 이름
                                                'members': filteredGroups[index].members,  // 멤버 정보 배열
                                              },
                                            ),
                                          ),
                                        ).then((_) {
                                          // GroupEditScreen에서 돌아오면 데이터를 새로 고침
                                          _reloadGroups(); // 그룹 데이터를 갱신
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          GroupListTile(
                                            title: groupName,  // 그룹 이름
                                            time: timeAgo(
                                              DateTime.parse(filteredGroups[index].createdAt), //
                                              DateTime.now(), //
                                            ),
                                            profileLength: filteredGroups[index].members.length,  // 멤버 수
                                            profileImage1: members[0].user.profileUrl,  // 첫 번째 멤버의 프로필 이미지
                                            profileImage2: profileImage2.isEmpty ? null : profileImage2,  // 두 번째 멤버의 프로필 이미지
                                            isSelected: false,  // 선택된 그룹 여부
                                          ),
                                          SizedBox(height: 12.h),
                                        ],
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
                _filteredGroupsNotifier.value = sortByRecent(groupList);
                break;
              case 'alphabetical':
                filterText = '가나다순';
                _filteredGroupsNotifier.value = sortByName(groupList);
                break;
              case 'frequent':
                filterText = '자주 만나는 그룹';
                _filteredGroupsNotifier.value = sortByCount(groupList);
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