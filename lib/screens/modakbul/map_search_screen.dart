import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/location_list_tile.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> locations = [
    {'name': '스타벅스 강남점', 'address': '서울특별시 강남구 강남대로 456', 'distance': '2km'},
    {'name': '이마트24 홍대점', 'address': '서울특별시 마포구 양화로 161', 'distance': '1.5km'},
    {'name': '롯데리아 종로점', 'address': '서울특별시 종로구 종로 55', 'distance': '3km'},
    {
      'name': '투썸플레이스 강남역점',
      'address': '서울특별시 강남구 테헤란로 123',
      'distance': '2.5km'
    },
    {'name': 'gs25 서울역점', 'address': '서울특별시 용산구 한강대로 405', 'distance': '4km'},
    {'name': '배스킨라빈스 신촌점', 'address': '서울특별시 서대문구 신촌로 22', 'distance': '3.2km'},
    {'name': 'cu 동대문점', 'address': '서울특별시 종로구 종로 123', 'distance': '1km'},
    {'name': '맥도날드 건대입구점', 'address': '서울특별시 광진구 능동로 108', 'distance': '5km'},
    {'name': '파리바게트 목동점', 'address': '서울특별시 양천구 목동로 23', 'distance': '2.8km'},
    {'name': '빽다방 여의도점', 'address': '서울특별시 영등포구 여의대방로 20', 'distance': '3.6km'},
    {'name': '던킨도너츠 강변역점', 'address': '서울특별시 광진구 구의동 546', 'distance': '6km'},
    {'name': 'kfc 신림점', 'address': '서울특별시 관악구 신림로 33', 'distance': '4.5km'},
    {'name': '이디야커피 합정점', 'address': '서울특별시 마포구 합정로 12', 'distance': '1.2km'},
    {
      'name': '할리스커피 압구정점',
      'address': '서울특별시 강남구 압구정로 456',
      'distance': '2.3km'
    },
    {'name': '버거킹 잠실점', 'address': '서울특별시 송파구 올림픽로 300', 'distance': '5.2km'},
    {'name': '세븐일레븐 명동점', 'address': '서울특별시 중구 명동로 55', 'distance': '2.7km'},
    {'name': '카페베네 신사역점', 'address': '서울특별시 강남구 논현로 12', 'distance': '3km'},
    {'name': '엔젤리너스 사당점', 'address': '서울특별시 동작구 사당로 20', 'distance': '4km'},
    {'name': '노브랜드 홍대점', 'address': '서울특별시 마포구 홍익로 26', 'distance': '1.8km'},
    {'name': '빕스 종각점', 'address': '서울특별시 종로구 종로 133', 'distance': '2.1km'},
  ];

  List<Map<String, String>> recentLocations = [
    {'name': '스타벅스 강남점', 'address': '서울특별시 강남구 강남대로 456', 'distance': '2km'},
    {'name': '이마트24 홍대점', 'address': '서울특별시 마포구 양화로 161', 'distance': '1.5km'},
    {'name': '롯데리아 종로점', 'address': '서울특별시 종로구 종로 55', 'distance': '3km'},
  ];

  List<Map<String, dynamic>> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterLocation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLocation() {
    setState(() {
      _filteredLocations = locations
          .where((location) =>
      location['name']!
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()) ||
          location['address']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSchemes.gray000,
      appBar: const BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: StyleConstants.defaultPadding),
              child: Column(
                children: [
                  SizedBox(
                    height: 14.h,
                  ),
                  CustomSearchBar(
                      hintText: '위치를 입력해주세요.', controller: _searchController),
                ],
              ),
            ),
            Builder(builder: (context) {
              if (_searchController.text.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: StyleConstants.defaultPadding),
                      child: Column(
                        children: [
                          SizedBox(height: 12.h),
                          SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                                onPressed: () {
                                  Routes.navigateTo(context, Routes.mapSelectScreen);
                                },
                                style: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .copyWith(
                                  // 기본값 0
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            StyleConstants.radiusSmall),
                                        side: BorderSide(
                                          width: 1.5.w,
                                          color: ColorSchemes.orange100,
                                        )),
                                  ),
                                  backgroundColor:
                                  WidgetStateProperty.resolveWith(
                                          (states) {
                                        if (states
                                            .contains(WidgetState.disabled)) {
                                          return ColorSchemes
                                              .gray200; // 비활성화 상태일 때의 배경색
                                        }
                                        return ColorSchemes.gray000; // 기본 배경색
                                      }), // 버튼 색상 적용
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 24.r,
                                      width: 24.r,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          IconPath.locationSearching,
                                          width: 16.r,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Text(
                                      '현재 위치로 모닥불 피우기',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body3
                                          .copyWith(
                                          color: ColorSchemes.orange200),
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '최근 검색한 위치',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine4
                                    .copyWith(color: ColorSchemes.gray500),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    recentLocations.clear();
                                  });
                                },
                                child: Text(
                                  '전체 삭제',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body3
                                      .copyWith(color: ColorSchemes.orange100),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                        ],
                      ),
                    ),
                    if (recentLocations.isNotEmpty)
                      ListView.builder(
                          itemCount: recentLocations.length,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              overlayColor: const WidgetStatePropertyAll(
                                  ColorSchemes.orange000),
                              onTap: () {
                                Routes.navigateTo(context, Routes.mapSelectScreen);
                              },
                              child: LocationListTile.isGrayIcon(
                                locationName: recentLocations[index]['name']!,
                                address: recentLocations[index]['address']!,
                                distance: recentLocations[index]['distance']!,
                                onPressed: () {
                                  setState(() {
                                    recentLocations.removeWhere(
                                            (recentLocation) =>
                                        recentLocation['address'] ==
                                            recentLocations[index]['address']);
                                  });
                                },
                              ),
                            );
                          })
                  ],
                );
              } else if (_filteredLocations.isEmpty) {
                return Column(
                  children: [
                    SizedBox(
                      height: 24.h,
                    ),
                    Center(
                      child: Text(
                        '검색 결과가 없습니다',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: ColorSchemes.gray300),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: StyleConstants.defaultPadding),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 24.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '검색 결과',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine4
                                    .copyWith(color: ColorSchemes.gray500),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '정확도 순',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body3
                                        .copyWith(color: ColorSchemes.gray300),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 14.h,
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                        itemCount: _filteredLocations.length,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){
                              Routes.navigateTo(context, Routes.mapSelectScreen);
                            },
                            overlayColor: const WidgetStatePropertyAll(
                                ColorSchemes.orange000),
                            child: LocationListTile(
                              locationName: _filteredLocations[index]['name'],
                              address: _filteredLocations[index]['address'],
                              distance: _filteredLocations[index]['distance'],
                            ),
                          );
                        })
                  ],
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
