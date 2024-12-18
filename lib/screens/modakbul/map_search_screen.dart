import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/models/place.dart';
import 'package:modakbul/providers/place_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/kakao_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/location_list_tile.dart';
import 'package:provider/provider.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> recentLocations = [
    {'name': '스타벅스 강남점', 'address': '서울특별시 강남구 강남대로 456', 'distance': '2km'},
    {'name': '이마트24 홍대점', 'address': '서울특별시 마포구 양화로 161', 'distance': '1.5km'},
    {'name': '롯데리아 종로점', 'address': '서울특별시 종로구 종로 55', 'distance': '3km'},
  ];

  List<Place> _filteredLocations = [];
  String? latitude;
  String? longitude;
  late Future getData;
  KakaoService kakaoService = KakaoService();
  Timer? _debounce;
  late PlaceProvider placeProvider;

  Future<void> getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      print('latitude: ${position.latitude.toString()}');
      print('longitude: ${position.longitude.toString()}');
    });
  }

  @override
  void initState() {
    getGeoData();
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Timer 해제
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _filterLocation();
    });
  }

  Future<void> _filterLocation() async {
    if (_searchController.text.isNotEmpty &&
        latitude != null &&
        longitude != null) {
      // Kakao API 호출 및 결과 가져오기
      List<Place> results = await kakaoService.getKeywordToAddress(
        _searchController.text.toLowerCase(),
        latitude!,
        longitude!,
      );

      setState(() {
        _filteredLocations = results; // 결과를 상태에 저장
      });
    } else {
      setState(() {
        _filteredLocations = []; // 검색어가 비었을 때 목록 초기화
      });
    }
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
                                  Routes.navigateTo(
                                      context, Routes.mapSelectScreen);
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
                            children: [
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                '최근 검색한 위치',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine4
                                    .copyWith(color: ColorSchemes.gray500),
                              ),
                              const Spacer(),
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
                              SizedBox(
                                width: 4.w,
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
                                Routes.navigateTo(
                                    context, Routes.mapSelectScreen);
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
                            children: [
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                '검색 결과',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine4
                                    .copyWith(color: ColorSchemes.gray500),
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '정확도 순',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body3
                                        .copyWith(color: ColorSchemes.gray300),
                                  )),
                              SizedBox(
                                width: 4.w,
                              ),
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
                          Place place = _filteredLocations[index];
                          double kilometers = (place.distance / 1000 * 10).round() / 10;
                          return InkWell(
                            onTap: () {
                              placeProvider = Provider.of<PlaceProvider>(context, listen: false);
                              placeProvider.distance = kilometers;
                              placeProvider.x = place.x;
                              placeProvider.y = place.y;
                              placeProvider.roadAddressName = place.roadAddressName;
                              placeProvider.placeName = place.placeName;
                              Routes.navigateTo(
                                  context, Routes.mapSelectScreen,);
                            },
                            overlayColor: const WidgetStatePropertyAll(
                                ColorSchemes.orange000),
                            child: LocationListTile(
                              locationName: place.placeName,
                              address: place.roadAddressName,
                              distance: '${kilometers}km',
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
