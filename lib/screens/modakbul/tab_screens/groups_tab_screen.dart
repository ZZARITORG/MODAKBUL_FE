import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/my_modakbul_list_tile.dart';

class GroupsTabScreen extends StatefulWidget {
  GroupsTabScreen({super.key});

  @override
  State<GroupsTabScreen> createState() => _GroupsTabScreenState();
}

class _GroupsTabScreenState extends State<GroupsTabScreen> {
  final List<Map<String, dynamic>> groups = [
    {
      'name': '개발자 커뮤니티',
      'createdDate': '2023-01-01',
      'members': [
        {'username': '김민수', 'profile': 'https://example.com/profile1.jpg'},
        {'username': '이서준', 'profile': 'https://example.com/profile2.jpg'},
        {'username': '박지훈', 'profile': 'https://example.com/profile3.jpg'}
      ]
    },
    {
      'name': 'AI 연구 모임',
      'createdDate': '2023-01-05',
      'members': [
        {'username': '최유리', 'profile': 'https://example.com/profile4.jpg'},
        {'username': '정다은', 'profile': 'https://example.com/profile5.jpg'}
      ]
    },
    {
      'name': '프로그래밍 동호회',
      'createdDate': '2023-01-10',
      'members': [
        {'username': '홍길동', 'profile': 'https://example.com/profile6.jpg'},
        {'username': '김하늘', 'profile': 'https://example.com/profile7.jpg'},
        {'username': '이하은', 'profile': 'https://example.com/profile8.jpg'},
        {'username': '최서윤', 'profile': 'https://example.com/profile9.jpg'}
      ]
    },
    {
      'name': '데이터 과학자 모임',
      'createdDate': '2023-01-15',
      'members': [
        {'username': '박준영', 'profile': 'https://example.com/profile10.jpg'},
        {'username': '윤지호', 'profile': 'https://example.com/profile11.jpg'}
      ]
    },
    {
      'name': '백엔드 개발자 클럽',
      'createdDate': '2023-01-20',
      'members': [
        {'username': '강다현', 'profile': 'https://example.com/profile12.jpg'},
        {'username': '송지민', 'profile': 'https://example.com/profile13.jpg'},
        {'username': '오수민', 'profile': 'https://example.com/profile14.jpg'},
        {'username': '임성현', 'profile': 'https://example.com/profile15.jpg'}
      ]
    },
    {
      'name': '프론트엔드 스터디',
      'createdDate': '2023-01-25',
      'members': [
        {'username': '서지우', 'profile': 'https://example.com/profile16.jpg'},
        {'username': '한승훈', 'profile': 'https://example.com/profile17.jpg'}
      ]
    },
    {
      'name': '모바일 개발 그룹',
      'createdDate': '2023-01-30',
      'members': [
        {'username': '문예진', 'profile': 'https://example.com/profile18.jpg'},
        {'username': '차은호', 'profile': 'https://example.com/profile19.jpg'},
        {'username': '전수빈', 'profile': 'https://example.com/profile20.jpg'}
      ]
    },
    {
      'name': '기술 혁신 모임',
      'createdDate': '2023-02-01',
      'members': [
        {'username': '김민수', 'profile': 'https://example.com/profile1.jpg'},
        {'username': '이서준', 'profile': 'https://example.com/profile2.jpg'},
        {'username': '박지훈', 'profile': 'https://example.com/profile3.jpg'}
      ]
    },
    {
      'name': 'IT 스타트업 포럼',
      'createdDate': '2023-02-05',
      'members': [
        {'username': '최유리', 'profile': 'https://example.com/profile4.jpg'},
        {'username': '정다은', 'profile': 'https://example.com/profile5.jpg'}
      ]
    },
    {
      'name': '클라우드 엔지니어링',
      'createdDate': '2023-02-10',
      'members': [
        {'username': '홍길동', 'profile': 'https://example.com/profile6.jpg'},
        {'username': '김하늘', 'profile': 'https://example.com/profile7.jpg'},
        {'username': '이하은', 'profile': 'https://example.com/profile8.jpg'},
        {'username': '최서윤', 'profile': 'https://example.com/profile9.jpg'},
        {'username': '박준영', 'profile': 'https://example.com/profile10.jpg'}
      ]
    },
    // 나머지 그룹들 생략 - 패턴 동일
  ];
  List<Map<String, dynamic>> _filteredGroups = [];
  final TextEditingController _searchController = TextEditingController();
  int? selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filteredGroups = groups;
    _searchController.addListener(_filterGroups);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectedGroup(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = null;
      } else {
        selectedIndex = index;
      }
    });
  }

  ///TODO 디바운딩 추가, TODO 검색방식 정하기
  void _filterGroups() {
    setState(() {
      _filteredGroups = groups
          .where((group) => group['name']
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: Column(
              children: [
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  height: 16.h,
                ),
                CustomSearchBar(
                  hintText: '그룹을 검색해보세요.',
                  controller: _searchController,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Builder(builder: (context) {
                  if (_filteredGroups.isEmpty) {
                    ///이부분 정하기
                    return Center(
                      child: Text(
                        '검색 결과가 없습니다',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: ColorSchemes.gray300),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 4.w,),
                            Text(
                              '최신순',
                              style: Theme.of(context)
                                  .textTheme
                                  .bigHeadLine4
                                  .copyWith(color: ColorSchemes.gray500),
                            ),
                            const Spacer(),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  '필터',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body3
                                      .copyWith(color: ColorSchemes.gray300),
                                )),
                            SizedBox(width: 4.w,),
                          ],
                        ),
                        SizedBox(height: 14.h,),
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
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
                        SizedBox(
                          height: 14.h,
                        ),
                        ListView.builder(
                            itemCount: _filteredGroups.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => _toggleSelectedGroup(index),
                                child: Column(
                                  children: [
                                    MyModakbulListTile(
                                      title: _filteredGroups[index]['name'],
                                      time: _filteredGroups[index]
                                      ['createdDate'],
                                      profileLength: _filteredGroups[index]
                                      ['members']
                                          .length,
                                      profileImage1: _filteredGroups[index]
                                      ['members'][0]['profile'],
                                      profileImage2: _filteredGroups[index]
                                      ['members'][1]['profile'],

                                      ///프로필 1,2를 보내지말고 members변수 자체를 보내면 댐
                                      isSelected: selectedIndex == index,
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ],
                    );
                  }
                }),
                SizedBox(height: 88.h),
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
                          onPressed: selectedIndex != null ? () {} : null,
                          buttonColor: ColorSchemes.orange200,
                          textStyle: Theme.of(context).textTheme.smallHeadLine2,
                          textColor: ColorSchemes.white),
                    )),
              ],
            ))
      ],
    );
  }
}
