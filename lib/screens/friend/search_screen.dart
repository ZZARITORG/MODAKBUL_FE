import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/screens/friend/tab_screens/custom_friends_tab_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/add_friend_profile.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/participant_list_profile.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';
import '../../constants/assets_path.dart';
import '../../constants/style_constants.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/logo_app_bar.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, dynamic>> friends = [
    {
      'username': '김민수asdasdasdasdasdsadsadsadadadadsadd',
      'id': 'user001',
      'profilePicture': 'https://example.com/profile1.jpg',
    },
    {
      'username': '이서준',
      'id': 'user002',
      'profilePicture': 'https://example.com/profile2.jpg',
    },
    {
      'username': '박지훈',
      'id': 'user003',
      'profilePicture': 'https://example.com/profile3.jpg',
    },
    {
      'username': '최유리',
      'id': 'user004',
      'profilePicture': 'https://example.com/profile4.jpg',
    },
    {
      'username': '정다은',
      'id': 'user005',
      'profilePicture': 'https://example.com/profile5.jpg',
    },
    {
      'username': '홍길동',
      'id': 'user006',
      'profilePicture': 'https://example.com/profile6.jpg',
    },
    {
      'username': '김하늘',
      'id': 'user007',
      'profilePicture': 'https://example.com/profile7.jpg',
    },
    {
      'username': '이하은',
      'id': 'user008',
      'profilePicture': 'https://example.com/profile8.jpg',
    },
    {
      'username': '최서윤',
      'id': 'user009',
      'profilePicture': 'https://example.com/profile9.jpg',
    },
    {
      'username': '박준영',
      'id': 'user010',
      'profilePicture': 'https://example.com/profile10.jpg',
    },
    {
      'username': '윤지호',
      'id': 'user011',
      'profilePicture': 'https://example.com/profile11.jpg',
    },
    {
      'username': '강다현',
      'id': 'user012',
      'profilePicture': 'https://example.com/profile12.jpg',
    },
    {
      'username': '송지민',
      'id': 'user013',
      'profilePicture': 'https://example.com/profile13.jpg',
    },
    {
      'username': '오수민',
      'id': 'user014',
      'profilePicture': 'https://example.com/profile14.jpg',
    },
    {
      'username': '임성현',
      'id': 'user015',
      'profilePicture': 'https://example.com/profile15.jpg',
    },
    {
      'username': '서지우',
      'id': 'user016',
      'profilePicture': 'https://example.com/profile16.jpg',
    },
    {
      'username': '한승훈',
      'id': 'user017',
      'profilePicture': 'https://example.com/profile17.jpg',
    },
    {
      'username': '문예진',
      'id': 'user018',
      'profilePicture': 'https://example.com/profile18.jpg',
    },
    {
      'username': '차은호',
      'id': 'user019',
      'profilePicture': 'https://example.com/profile19.jpg',
    },
    {
      'username': '전수빈',
      'id': 'user020',
      'profilePicture': 'https://example.com/profile20.jpg',
    },
  ];

  List<Map<String, String>> selectedFridnds = [];
  List<Map<String, dynamic>> _filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _filteredFriends = friends;
    _searchController.addListener(_filterFriends);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
      if (selectedFridnds.any((friend) => friend['userId'] == userId)) {
        selectedFridnds.removeWhere((friend) => friend['userId'] == userId);
      } else {
        selectedFridnds.add(friend);
      }
    });
  }

  ///TODO 디바운딩 추가, TODO 검색방식 정하기
  void _filterFriends() {
    setState(() {
      _filteredFriends = friends
          .where((friend) =>
      friend['username']
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()) ||
          friend['id']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              CustomSearchBar(
                hintText: '사용자를 검색해보세요.',
                controller: _searchController,
              ),
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
              Expanded(
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: _filteredFriends.length,
                  itemBuilder: (BuildContext context, int index) {
                    final friend = _filteredFriends[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                        onTap: () {
                          final selectedFriend = _filteredFriends[index];
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
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
                                                  selectedFriend['username'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bigHeadLine2
                                                      .copyWith(color: ColorSchemes.gray500),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  selectedFriend['id'],
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
                                            backgroundImage: NetworkImage(selectedFriend['profilePicture']),
                                            backgroundColor: ColorSchemes.gray500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56.h,
                                        child: CustomButton(
                                            text: '친구수락',
                                            onPressed: () {},
                                            buttonColor: ColorSchemes.orange200,
                                            textStyle: Theme.of(context)
                                            .textTheme
                                            .smallHeadLine2,
                                            textColor: Colors.white
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 56.h),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        onTapDown: (_) {},
                      child: Participantlistprofile(
                        userName: _filteredFriends[index]['username'],
                        userId: _filteredFriends[index]['id'],
                        profileImage: _filteredFriends[index]['profilePicture'],)
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
