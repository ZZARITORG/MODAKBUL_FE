import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/screens/home/tab_screens/browse_tab_screen.dart';
import 'package:modakbul/screens/home/tab_screens/default_tab_screen.dart';
import 'package:modakbul/services/notification_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';

import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/widgets/custom_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationService notificationService = NotificationService();
  final ValueNotifier<bool> _hasNotification = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    notificationService.notificationStream.listen((hasNotification) {
      _hasNotification.value = hasNotification;
    });
    notificationService.subscribeToNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    notificationService.dispose();
    _hasNotification.dispose();
    super.dispose();
  }

  void _navigateToAlertScreen(bool hasNotification) {
    if (hasNotification) {
      notificationService.clearNotification();
    }
    Routes.navigateTo(context, Routes.alertScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: ValueListenableBuilder<bool>(
            valueListenable: _hasNotification,
            builder: (context, hasNotification, _) {
              return LogoAppBar.actions(
                onActionPressed: () => _navigateToAlertScreen(hasNotification),
                backgroundColor: ColorSchemes.gray000,
                hasNotification: hasNotification,
              );
            }
        ),
      ),
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
              children: const [
                DefaultTabScreen(),
                BrowseTabScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}