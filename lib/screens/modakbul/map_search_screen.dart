import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:lottie/lottie.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/address.dart' as address_model;
import 'package:modakbul/models/place.dart';
import 'package:modakbul/providers/place_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/kakao_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/location_manager.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/location_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:modakbul/providers/location_provider.dart';

import '../../utils/json_utils.dart';
import '../../widgets/custom_toast.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> recentLocations = [
    {'name': '스타벅스 강남점', 'address': '서울특별시 강남구 강남대로 456', 'distance': '2km'},
    {'name': '이마트24 홍대점', 'address': '서울특별시 마포구 양화로 161', 'distance': '1.5km'},
    {'name': '롯데리아 종로점', 'address': '서울특별시 종로구 종로 55', 'distance': '3km'},
  ];

  List<Place> _filteredLocations = [];
  double? latitude;
  double? longitude;
  late Future getData;
  KakaoService kakaoService = KakaoService();
  Timer? _debounce;
  late PlaceProvider placeProvider;
  String selectedFilter = 'accuracy';
  String filterText = '정확도 순';
  late AnimationController _lottieController;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isSearching = false;
  bool showLottie = false;
  int page = 1;
  bool isEnd = false;

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
      latitude = position.latitude;
      longitude = position.longitude;
      print('latitude: ${position.latitude.toString()}');
      print('longitude: ${position.longitude.toString()}');
    });
  }

  @override
  void initState() {
    ///getGeoData();
    super.initState();
    Position? currentPosition =
        Provider.of<LocationProvider>(context, listen: false).currentPosition;
    latitude = currentPosition?.latitude;
    longitude = currentPosition?.longitude;
    print('latitude: ${latitude.toString()}');
    print('longitude: ${longitude.toString()}');
    _searchController.addListener(_onSearchChanged);
    _lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _lottieController.repeat();
    _scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Timer 해제
    _lottieController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool areListsEqual(List<dynamic> list1, List<dynamic> list2) {
    final equality = ListEquality();
    return equality.equals(list1, list2);
  }

  void onScroll() async {
    if (!isEnd) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
            showLottie = true;
          });
          _lottieController.repeat();
          final response = await kakaoService.getKeywordToAddress(
              _searchController.text.toLowerCase(),
              latitude!.toString(),
              longitude!.toString(),
              selectedFilter,
              page
          );
          List<Place> results = JsonUtils.convertJsonToPlaceList(response['documents'] as List);
          isEnd = response['meta']['is_end'];
          print('page: $page, users: ${results.toString()}, isEnd: $isEnd');
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            _filteredLocations.addAll(results);
            page++;
            isLoading = false;
            showLottie = false;
          });
          _lottieController.stop();
        }
      }
    }
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
      final response = await kakaoService.getKeywordToAddress(
          _searchController.text.toLowerCase(),
          latitude!.toString(),
          longitude!.toString(),
          selectedFilter,
          1
      );
      List<Place> results = JsonUtils.convertJsonToPlaceList(response['documents'] as List);
      isEnd = response['meta']['is_end'];
      page ++;

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
    placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    List<Map<String, dynamic>> recentSearchList =
        LocationManager.getLocations();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSchemes.gray000,
      appBar: const BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: StyleConstants.defaultPadding),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                CustomSearchBar(
                    hintText: '위치를 입력해주세요.', controller: _searchController),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                controller: _scrollController,
                //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Builder(builder: (context) {
                  if (_searchController.text.isEmpty) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: StyleConstants.defaultPadding),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 48.h,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      //현재 위치 없을때 토스트 띄우기
                                      if (latitude != null && longitude != null) {
                                        List<address_model.Address> address =
                                            await kakaoService.getCoordToAddress(
                                                latitude!.toString(),
                                                longitude!.toString());
                                        placeProvider.placeName = address[0]
                                                        .roadAddress
                                                        ?.addressName ==
                                                    '' ||
                                                address[0].roadAddress == null
                                            ? address[0].detailedAddress.addressName
                                            : address[0].roadAddress?.addressName;
                                        placeProvider.roadAddressName =
                                            address[0].detailedAddress.addressName;
                                        placeProvider.x = longitude!;
                                        placeProvider.y = latitude!;
                                        Routes.navigateTo(
                                            context, Routes.mapSelectScreen);
                                      } else {
                                        CustomToast.showToast(
                                            context, '위치 권한이 없습니다.', false);
                                      }
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
                                        LocationManager.clearLocations();
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
                            ],
                          ),
                        ),
                        if (recentSearchList.isNotEmpty) ...[
                          SizedBox(
                            height: 14.h,
                          ),
                          ListView.builder(
                              itemCount: recentSearchList.length,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final latlong.Distance distance =
                                    latlong.Distance();
                                double distanceMeter = distance(
                                    latlong.LatLng(latitude!, longitude!),
                                    latlong.LatLng(recentSearchList[index]['y']!,
                                        recentSearchList[index]['x']!));
                                double kilometers =
                                    (distanceMeter / 1000 * 10).round() / 10;
                                return InkWell(
                                  overlayColor: const WidgetStatePropertyAll(
                                      ColorSchemes.orange000),
                                  onTap: () {
                                    placeProvider.placeName =
                                        recentSearchList[index]['placeName']!;
                                    placeProvider.roadAddressName =
                                        recentSearchList[index]['roadAddressName']!;
                                    placeProvider.x = recentSearchList[index]['x']!;
                                    placeProvider.y = recentSearchList[index]['y']!;
                                    placeProvider.distance =
                                        recentSearchList[index]['distance']!;
                                    Routes.navigateTo(
                                        context, Routes.mapSelectScreen);
                                  },
                                  child: LocationListTile.isGrayIcon(
                                    locationName: recentSearchList[index]
                                        ['placeName']!,
                                    address: recentSearchList[index]
                                        ['roadAddressName']!,
                                    //이부분 현재위치에서 불러오게끔 바꾸기
                                    distance: '$kilometers km',
                                    onPressed: () {
                                      setState(() {
                                        LocationManager.removeLocation(index);
                                      });
                                    },
                                  ),
                                );
                              }),
                        ]
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
                                height: 12.h,
                              ),
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
                                        .copyWith(color: ColorSchemes.gray500),
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
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    StyleConstants.radiusLarge),
                                                topRight: Radius.circular(
                                                    StyleConstants.radiusLarge),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: StyleConstants
                                                      .defaultPadding),
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
                                                            .copyWith(
                                                                color: ColorSchemes
                                                                    .gray500),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 24.h),
                                                  _buildFilterOption(
                                                      '정확도 순', 'accuracy', context),
                                                  SizedBox(height: 24.h),
                                                  _buildFilterOption(
                                                      '거리 순', 'distance', context),
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
                                          .copyWith(color: ColorSchemes.gray300),
                                    ),
                                  ),
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
                            itemCount:
                                _filteredLocations.length + (showLottie ? 1 : 0),
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < _filteredLocations.length) {
                                Place place = _filteredLocations[index];
                                double kilometers =
                                    (place.distance / 1000 * 10).round() / 10;
                                return InkWell(
                                  onTap: () async {
                                    placeProvider.distance = kilometers;
                                    placeProvider.x = place.x;
                                    placeProvider.y = place.y;
                                    placeProvider.roadAddressName =
                                        place.roadAddressName == ''
                                            ? place.addressName
                                            : place.roadAddressName;
                                    placeProvider.placeName = place.placeName;
                                    Map<String, dynamic> recentSearch = {
                                      'placeName': placeProvider.placeName,
                                      'roadAddressName':
                                          placeProvider.roadAddressName,
                                      'x': placeProvider.x,
                                      'y': placeProvider.y,
                                      'distance': placeProvider.distance
                                    };
                                    await LocationManager.addLocation(recentSearch);
                                    Routes.navigateTo(
                                      context,
                                      Routes.mapSelectScreen,
                                    );
                                  },
                                  overlayColor: const WidgetStatePropertyAll(
                                      ColorSchemes.orange000),
                                  child: LocationListTile(
                                    locationName: place.placeName,
                                    address: place.roadAddressName == ''
                                        ? place.addressName
                                        : place.roadAddressName,
                                    distance: '${kilometers}km',
                                  ),
                                );
                              } else if (index == _filteredLocations.length && showLottie) {
                                return SizedBox(
                                  height: 72.h,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 14.h, bottom: 26.h), // 위쪽 14, 아래쪽 26 간격
                                    child: Center(
                                      child: SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: Lottie.asset(
                                          controller: _lottieController,
                                          AnimationPath.loadingFeed,
                                          fit: BoxFit.contain,
                                          repeat: true,
                                          animate: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            })
                      ],
                    );
                  }
                }),
              ),
            ),
          ),
        ],
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
              case 'accuracy':
                filterText = '정확도 순';
                //_filteredGroupsNotifier.value = sortByRecent(groupList);
                selectedFilter = 'accuracy';
                setState(() {
                  _filterLocation();
                });
                break;
              case 'distance':
                filterText = '거리 순';
                //_filteredGroupsNotifier.value = sortByName(groupList);
                selectedFilter = 'distance';
                setState(() {
                  _filterLocation();
                });
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
