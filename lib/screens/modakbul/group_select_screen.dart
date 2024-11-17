import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/screens/modakbul/tab_screens/friends_tab_screen.dart';
import 'package:modakbul/screens/modakbul/tab_screens/groups_tab_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';

class GroupSelectScreen extends StatefulWidget {
  const GroupSelectScreen({super.key});

  @override
  State<GroupSelectScreen> createState() => _GroupSelectScreenState();
}

///TODO SingleTickerProviderStateMixin 공부
class _GroupSelectScreenState extends State<GroupSelectScreen> with SingleTickerProviderStateMixin {
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
        FocusManager.instance.primaryFocus?.unfocus();
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
      appBar: const BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: DefaultTabController(
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
    );
  }
}
