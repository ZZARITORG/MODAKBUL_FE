import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/providers/location_provider.dart';
import 'package:modakbul/screens/friend/friend_screen.dart';
import 'package:modakbul/screens/friend/friend_search_screen.dart';
import 'package:modakbul/screens/home/home_screen.dart';
import 'package:modakbul/screens/modakbul/create_modakbul_screen.dart';
import 'package:modakbul/screens/setting/my_profile_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/utils/handler_utils.dart';
import 'package:modakbul/utils/location_utils.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> _icons = [
    {
      'activate': IconPath.homeBottomActivate,
      'disable': IconPath.homeBottomDisable,
      'width': 23.r,
    },
    {
      'activate': IconPath.groupBottomActivate,
      'disable': IconPath.groupBottomDisable,
      'width': 25.r,
    },
    {
      'activate': IconPath.modakbulBottomActivate,
      'disable': IconPath.modakbulBottomDisable,
      'width': 21.r,
    },
    {
      'activate': IconPath.searchBottomActivate,
      'disable': IconPath.searchBottomDisable,
      'width': 22.r,
    },
    {
      'activate': IconPath.settingsBottomActivate,
      'disable': IconPath.settingsBottomDisable,
      'width': 25.r,
    },
  ];

  // 키를 사용하여 리빌드 제어
  Key getKey(int index) => ValueKey('screen_$index${DateTime.now().millisecondsSinceEpoch}');

  Widget _getScreen(int index) {
    // 매번 새로운 키를 생성하여 리빌드 강제
    return KeyedSubtree(
      key: getKey(index),
      child: switch (index) {
        0 => const HomeScreen(),
        1 => const FriendScreen(),
        2 => const CreateModakbulScreen(),
        3 => const FriendSearchScreen(),
        4 => MyProfileScreen(),
        _ => const HomeScreen(),
      },
    );
  }

  HandlerUtils handlerUtils = HandlerUtils();
  LocationUtils locationUtils = LocationUtils();

  @override
  void initState() {
    super.initState();
    Position? currentPosition = Provider.of<LocationProvider>(context, listen: false).currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(selectedIndex),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 56.h,
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_icons.length, (index) {
              return InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: SizedBox(
                  width: 64.w,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: 32.r,
                          height: 32.r,
                          child: Center(
                            child: SvgPicture.asset(
                              selectedIndex == index
                                  ? _icons[index]['activate']!
                                  : _icons[index]['disable']!,
                              width: _icons[index]['width'],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        if (selectedIndex == index)
                          Container(
                            width: 4.r,
                            height: 4.r,
                            decoration: const BoxDecoration(
                              color: ColorSchemes.orange200,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}