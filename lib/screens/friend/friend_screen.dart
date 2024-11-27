import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/screens/friend/tab_screens/friends_tab_screen.dart';
import 'package:modakbul/screens/friend/tab_screens/groups_tab_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

///TODO SingleTickerProviderStateMixin 공부
class _FriendScreenState extends State<FriendScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      // 탭이 변경될 때 스크롤 위치 초기화
      if (_tabController.indexIsChanging) {
        // FriendsTabScreen과 GroupsTabScreen에서 각각 ScrollController를 관리하고
        // 여기서 해당 controller의 animateTo를 호출
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            scrollDirection: Axis.vertical,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPersistentHeader(
                pinned: true,
                delegate: TabBarDelegate(
                    tabController: _tabController,
                    leftTabTitle: '친구',
                    rightTabTitle: '그룹',
                    maxHeight: 58.h,
                    minHeight: 58.h,
                    isRebuild: false),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                FriendsTabScreen(),
                GroupsTabScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}