import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:modakbul/widgets/user_info_check.dart';

///TODO 검색방식 생각, 키보드 내리는것도 생각(탭바 안쓸수도있음), 리스트 끝까지올렸을때 마진 고려
class CustomFriendsTabScreen extends StatefulWidget {
  const CustomFriendsTabScreen ({super.key});

  @override
  State<CustomFriendsTabScreen > createState() => _CustomFriendsTabScreenState();
}

class _CustomFriendsTabScreenState extends State<CustomFriendsTabScreen > {
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
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 24.h
            ),
            if (selectedFridnds.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 4.w, left: StyleConstants.defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: selectedFridnds.map((friend) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: StyleConstants.circleSizeM,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: SizedBox(
                                  height: 24.r,
                                  width: 24.r,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      setState(() {
                                        selectedFridnds.removeWhere(
                                              (item) => item['userId'] == friend['userId'],
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
                          SizedBox(
                              height: 4.h
                          ),
                          SizedBox(
                            width: StyleConstants.circleSizeM * 2,
                            child: Center(
                              child: Text(
                                friend['userName']!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .body3
                                    .copyWith(color: ColorSchemes.gray300),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            SizedBox(
                height: 10.h
            ),
            CustomSearchBar(
              hintText: '그룹을 검색해보세요.',
              controller: _searchController,
              focusNode: _searchFocusNode,
            ),
            SizedBox(
                height: 24.h
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      if (_filteredFriends.isEmpty) {
                        return Center(
                          child: Text(
                            '검색 결과가 없습니다',
                            style: Theme.of(context).textTheme.body1.copyWith(color: ColorSchemes.gray300),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '자주 만나는 친구',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bigHeadLine4
                                      .copyWith(color: ColorSchemes.gray500),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '정렬',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body3
                                        .copyWith(color: ColorSchemes.gray300),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 14.h
                            ),
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _filteredFriends.length,
                              itemBuilder: (BuildContext context, int index) {
                                final friend = _filteredFriends[index];
                                final isChecked = selectedFridnds.any((selectedFriend) =>
                                selectedFriend['userId'] == friend['id']);
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _toggleSelectGroup(friend['id'], friend['username'], friend['profilePicture']);
                                    _filteredFriends = friends;
                                    _searchController.text = '';
                                  },
                                  onTapDown: (_) {},
                                  child: SelectUserListProfile(
                                    userName: _filteredFriends[index]['username'],
                                    userId: _filteredFriends[index]['id'],
                                    profileImage: _filteredFriends[index]['profilePicture'],
                                    isChecked: isChecked,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                    }),
                    SizedBox(
                        height: 88.h
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 16.h,
          right: 16.h,
          child: Stack(
            children: [
              SizedBox(
                  height: 72.h
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
                    text: '그룹 만들기',
                    onPressed: selectedFridnds.isNotEmpty ? () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 10.h),
                                  UserInfoCheck(text: '그룹 이름을 입력해주세요', onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                                  SizedBox(height: 32.h),
                                  Stack(
                                    children: [
                                      TextField(
                                        maxLength: AppConstants.maxAddressLength,
                                        cursorColor: ColorSchemes.orange100,
                                        onTapOutside: (event) =>
                                            FocusManager.instance.primaryFocus?.unfocus(),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        style: Theme.of(context).textTheme.body1.copyWith(
                                            color: ColorSchemes.gray500
                                        ),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          hintText: '예) 자주 만나는 친구',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .body1
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
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          height: 2.w,
                                          decoration: BoxDecoration(
                                              color: ColorSchemes.gray100,
                                              borderRadius: BorderRadius.circular(2.r)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56.h,
                                    child: CustomButton(text: '모임 생성', onPressed: () {}, buttonColor: ColorSchemes.orange200,
                                        textStyle: Theme.of(context).textTheme.smallHeadLine2, textColor: ColorSchemes.white),
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } : null,
                    buttonColor: ColorSchemes.orange200,
                    textStyle: Theme.of(context).textTheme.smallHeadLine2,
                    textColor: ColorSchemes.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}