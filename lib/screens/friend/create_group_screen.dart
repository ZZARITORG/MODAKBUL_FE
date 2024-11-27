import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/screens/friend/tab_screens/custom_friends_tab_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';
import '../../constants/assets_path.dart';
import '../../constants/style_constants.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

///TODO SingleTickerProviderStateMixin 공부
class _CreateGroupScreenState extends State<CreateGroupScreen>
    with SingleTickerProviderStateMixin {
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
    return const Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomFriendsTabScreen(),
          )
        ],
      ),
    );
  }
}
