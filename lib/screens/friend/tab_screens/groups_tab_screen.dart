import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/group_list.dart';
import 'package:modakbul/screens/friend/create_group_screen.dart';
import 'package:modakbul/screens/friend/group_edit_screen.dart';
import 'package:modakbul/services/group_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/global_error_widget.dart';
import 'package:modakbul/widgets/group_list_tile.dart';
import 'package:modakbul/widgets/group_screen_skeleton.dart';

class GroupsTabScreen extends StatefulWidget {
  @override
  State<GroupsTabScreen> createState() => _GroupsTabScreenState();
}

class _GroupsTabScreenState extends State<GroupsTabScreen> {
  String selectedFilter = 'latest';
  String filterText = '최신순';
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController = ScrollController();
  GroupService groupService = GroupService();
  DioClient _dioClient = DioClient();
  List<Group> groupList = [];
  final FocusNode _searchFocusNode = FocusNode();
  late Future<List<Group>> getData;
  late DateTime currentTime;
  bool _isRefreshing = false;
  Timer? _debounce;
  final ValueNotifier<List<Group>> _filteredGroupsNotifier = ValueNotifier([]);
  static const double _maxDragOffset = 36; // 새로고침 인디케이터를 위한 변수

  @override
  void initState() {
    super.initState();
    getData = _dioClient.handleRequest<List<Group>>(
        requestFunction: () => groupService.getGroupList());
    _searchController.addListener(_onSearchChanged);
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
      getData = groupService.getGroupList();
    });
  }

  void _onGroupEdit() {
    _reloadGroups();
    Navigator.pop(context);
  }

  // 최신순 정렬 함수
  List<Group> sortByRecent(List<Group> data) {
    data.sort((a, b) {
      DateTime dateA = DateTime.parse(a.createdAt!);
      DateTime dateB = DateTime.parse(b.createdAt!);
      return dateB.compareTo(dateA);
    });
    return data;
  }

  // 자주 만나는 그룹 순 정렬 함수
  List<Group> sortByCount(List<Group> data) {
    data.sort((a, b) => b.count.compareTo(a.count));
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
    Duration difference = currentTime.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전 모닥불을 피웠습니다!';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    getData = groupService.getGroupList();
    _filteredGroupsNotifier.value = [];

    setState(() {
      _isRefreshing = false;
    });
  }

  // 인디케이터 애니메이션 에셋 선택 함수
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
              children: <Widget>[
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
            onVerticalDragDown: (_) =>
                FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: StyleConstants.defaultPadding),
                    child: FutureBuilder<List<Group>>(
                      future: getData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const GroupScreenSkeleton();
                        } else if (snapshot.hasError) {
                          return const GlobalErrorWidget();
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          _filteredGroupsNotifier.value = [];
                          return Column(
                            children: [
                              SizedBox(height: 10.h),
                              CustomSearchBar(
                                hintText: '사용자를 검색해보세요.',
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(height: 14.h),
                              Row(
                                children: [
                                  SizedBox(width: 4.w),
                                  Text(
                                    filterText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bigHeadLine4
                                        .copyWith(
                                            color: ColorSchemes.gray500),
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
                                                  _buildFilterOption('최신순',
                                                      'latest', context),
                                                  SizedBox(height: 24.h),
                                                  _buildFilterOption(
                                                      '가나다순',
                                                      'alphabetical',
                                                      context),
                                                  SizedBox(height: 24.h),
                                                  _buildFilterOption(
                                                      '자주 만나는 그룹',
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
                                      '정렬',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body3
                                          .copyWith(
                                              color: ColorSchemes.gray300),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateGroupScreen()),
                                  ).then((_) {
                                    _reloadGroups();
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium),
                                    ),
                                    color: ColorSchemes.gray100,
                                    margin: EdgeInsets.zero,
                                    elevation: 0,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.h, bottom: 14.h),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: StyleConstants
                                                .circleSizeXXXS,
                                            backgroundColor:
                                                ColorSchemes.gray300,
                                            child: SvgPicture.asset(
                                                IconPath.plus,
                                                width: 11.r),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            '그룹 생성하기',
                                            style: Theme.of(context)
                                                .textTheme
                                                .smallHeadLine3
                                                .copyWith(
                                                    color: ColorSchemes
                                                        .gray200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 144.h,
                              ),
                              Text(
                                '아직 그룹이 없습니다',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine3
                                    .copyWith(
                                        color: ColorSchemes.orange100),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '그룹을 생성하고 모닥불을 피워보세요.',
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(color: ColorSchemes.gray300),
                              ),
                            ],
                          );
                        } else {
                          groupList = snapshot.data!;
                          _filteredGroupsNotifier.value = groupList;
                          return Column(
                            children: [
                              SizedBox(height: 10.h),
                              CustomSearchBar(
                                hintText: '사용자를 검색해보세요.',
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                              ),
                              SizedBox(height: 10.h),
                              Column(
                                children: [
                                  SizedBox(height: 14.h),
                                  Row(
                                    children: [
                                      Text(
                                        filterText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bigHeadLine4
                                            .copyWith(
                                                color:
                                                    ColorSchemes.gray500),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder:
                                                (BuildContext context) {
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
                                                      horizontal:
                                                          StyleConstants
                                                              .defaultPadding),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                          height: 38.h),
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
                                                      SizedBox(
                                                          height: 24.h),
                                                      _buildFilterOption(
                                                          '최신순',
                                                          'latest',
                                                          context),
                                                      SizedBox(
                                                          height: 24.h),
                                                      _buildFilterOption(
                                                          '가나다순',
                                                          'alphabetical',
                                                          context),
                                                      SizedBox(
                                                          height: 24.h),
                                                      _buildFilterOption(
                                                          '자주 만나는 그룹',
                                                          'frequent',
                                                          context),
                                                      SizedBox(
                                                          height: 56.h),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          '정렬',
                                          style: Theme.of(context)
                                              .textTheme
                                              .body3
                                              .copyWith(
                                                  color:
                                                      ColorSchemes.gray300),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 14.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateGroupScreen()),
                                        ).then((_) {
                                          _reloadGroups();
                                        });
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    StyleConstants
                                                        .radiusMedium),
                                          ),
                                          color: ColorSchemes.gray100,
                                          margin: EdgeInsets.zero,
                                          elevation: 0,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.h, bottom: 14.h),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: StyleConstants
                                                      .circleSizeXXXS,
                                                  backgroundColor:
                                                      ColorSchemes.gray300,
                                                  child: SvgPicture.asset(
                                                      IconPath.plus,
                                                      width: 11.r),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  '그룹 생성하기',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .smallHeadLine3
                                                      .copyWith(
                                                          color:
                                                              ColorSchemes
                                                                  .gray200),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  ValueListenableBuilder<List<Group>>(
                                    valueListenable:
                                        _filteredGroupsNotifier,
                                    builder: (context, filteredGroups, _) {
                                      if (filteredGroups.isEmpty) {
                                        return Column(
                                          children: [
                                            SizedBox(height: 144.h),
                                            Text(
                                              '검색 결과가 없습니다',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bigHeadLine3
                                                  .copyWith(
                                                      color: ColorSchemes
                                                          .orange100),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              '검색어를 다시 확인해 주세요.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2
                                                  .copyWith(
                                                      color: ColorSchemes
                                                          .gray300),
                                            ),
                                          ],
                                        );
                                      }
                                      return ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: filteredGroups.length,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          String groupName =
                                              filteredGroups[index].name;
                                          String groupId =
                                              filteredGroups[index].id;
                                          var members =
                                              filteredGroups[index].members;
                                          String profileImage2 =
                                              members.length > 1
                                                  ? members[1]
                                                      .user
                                                      .profileUrl
                                                  : '';
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GroupEditScreen(),
                                                  settings: RouteSettings(
                                                    arguments: {
                                                      'groupId':
                                                          filteredGroups[
                                                                  index]
                                                              .id,
                                                      'groupName':
                                                          filteredGroups[
                                                                  index]
                                                              .name,
                                                      'members':
                                                          filteredGroups[
                                                                  index]
                                                              .members,
                                                    },
                                                  ),
                                                ),
                                              ).then((_) {
                                                _reloadGroups();
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                GroupListTile(
                                                  title: groupName,
                                                  time: timeAgo(
                                                    DateTime.parse(
                                                        filteredGroups[
                                                                index]
                                                            .createdAt),
                                                    DateTime.now(),
                                                  ),
                                                  profileLength:
                                                      filteredGroups[index]
                                                          .members
                                                          .length,
                                                  profileImage1: members[0]
                                                      .user
                                                      .profileUrl,
                                                  profileImage2:
                                                      profileImage2.isEmpty
                                                          ? null
                                                          : profileImage2,
                                                  isSelected: false,
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      StyleConstants
                                                                          .radiusLarge),
                                                              topRight: Radius
                                                                  .circular(
                                                                      StyleConstants
                                                                          .radiusLarge),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    StyleConstants
                                                                        .defaultPadding),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                        38.h),
                                                                Text(
                                                                    groupName,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .bigHeadLine3
                                                                        .copyWith(color: ColorSchemes.gray500)),
                                                                SizedBox(
                                                                    height:
                                                                        24.h),
                                                                InkWell(
                                                                  overlayColor:
                                                                      WidgetStateProperty.all(
                                                                          Colors.transparent),
                                                                  onTap:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            GroupEditScreen(),
                                                                        settings:
                                                                            RouteSettings(
                                                                          arguments: {
                                                                            'groupId': filteredGroups[index].id,
                                                                            'groupName': filteredGroups[index].name,
                                                                            'members': filteredGroups[index].members,
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ).then(
                                                                        (_) {
                                                                      _reloadGroups();
                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          '그룹 수정하기',
                                                                          style: Theme.of(context).textTheme.smallHeadLine2.copyWith(color: ColorSchemes.gray300)),
                                                                      SizedBox(
                                                                        width:
                                                                            24.r,
                                                                        height:
                                                                            24.r,
                                                                        child:
                                                                            Center(
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
                                                                SizedBox(
                                                                    height:
                                                                        24.h),
                                                                InkWell(
                                                                  overlayColor:
                                                                      WidgetStateProperty.all(
                                                                          Colors.transparent),
                                                                  onTap:
                                                                      () async {
                                                                    await groupService
                                                                        .deleteGroup(groupId);
                                                                    setState(
                                                                        () {
                                                                      filteredGroups.removeWhere((group) =>
                                                                          group.id ==
                                                                          groupId);
                                                                      _filteredGroupsNotifier.value =
                                                                          List<Group>.from(groupList);
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          '그룹 삭제하기',
                                                                          style: Theme.of(context).textTheme.smallHeadLine2.copyWith(color: ColorSchemes.gray300)),
                                                                      SizedBox(
                                                                        width:
                                                                            24.r,
                                                                        height:
                                                                            24.r,
                                                                        child:
                                                                            Center(
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
                                                                SizedBox(
                                                                    height:
                                                                        56.h),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
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
                              ),
                            ],
                          );
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
