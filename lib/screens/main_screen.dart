import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/screens/friend/friend_screen.dart';
import 'package:modakbul/screens/friend/friend_search_screen.dart';
import 'package:modakbul/screens/home/home_screen.dart';
import 'package:modakbul/screens/modakbul/create_modakbul_screen.dart';
import 'package:modakbul/screens/setting/my_profile_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

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

  final List<Widget> _screens = [
    const HomeScreen(),
    const FriendScreen(),
    const CreateModakbulScreen(),
    const FriendSearchScreen(),
    const MyProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 56.h,
        elevation: 0, // 그림자 없애기
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_icons.length, (index) {
              return InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: SizedBox(
                      width: 64.w,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 8.h,),
                            SizedBox(
                              width: 32.r,
                              height: 32.r,
                              child: Center(
                                child:
                                    SvgPicture.asset(
                                      _selectedIndex == index
                                          ? _icons[index]['activate']!
                                          : _icons[index]['disable']!,
                                      width: _icons[index]['width'],
                                    ),
                              ),
                            ),
                            SizedBox(height: 2.h,),
                            if (_selectedIndex == index)
                              Container(
                                width: 4.r, // 원의 크기
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
