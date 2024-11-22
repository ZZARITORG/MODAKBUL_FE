import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/screens/home/tab_screens/default_tab_screen.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';

import '../../widgets/custom_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar.actions(onActionPressed: (){}),
      body: Column(
        children: [
          CustomTabBar(
            tabController: _tabController,
            leftTabTitle: '홈',
            rightTabTitle: '둘러보기',
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DefaultTabScreen(),
                Center(child: Text('둘러보기', style: TextStyle(fontSize: 18.sp))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
