import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/screens/friend/tab_screens/custom_friends_tab_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/add_friend_profile.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';
import '../../constants/assets_path.dart';
import '../../constants/style_constants.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/logo_app_bar.dart';


class AddFreindScreen extends StatefulWidget {
  const AddFreindScreen({super.key});

  @override
  State<AddFreindScreen> createState() => _AddFreindScreenState();
}

class _AddFreindScreenState extends State<AddFreindScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> friendRequests = [
    {'userName': '김지호', 'userId': '123', 'time': '1분전'},
    {'userName': '양지원', 'userId': '345', 'time': '5분전'},
    {'userName': '김태현', 'userId': '456', 'time': '10분전'},
    {'userName': '주해찬', 'userId': '567', 'time': '30분전'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
        onActionPressed: () {},
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '친구요청',
                      style: Theme.of(context)
                          .textTheme
                          .bigHeadLine4
                          .copyWith(color: ColorSchemes.gray500),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final friend = friendRequests[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: AddFriendProfile(
                        userName: friend['userName']!,
                        userId: friend['userId']!,
                        time: friend['time']!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
