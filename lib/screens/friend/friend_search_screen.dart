import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/add_friend_profile.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/search_screen_skeleton.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';
import '../../constants/assets_path.dart';
import '../../constants/style_constants.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/logo_app_bar.dart';
import 'create_group_screen.dart';


class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
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
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body:/*Skeleton 들어갈 자리 */ SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    CustomSearchBar(
                      hintText: '사용자를 검색해보세요.',
                      controller: _searchController,
                    ),
                    SizedBox(height: 24.h),
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
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateGroupScreen()), // AddFreindScreen 으로 이동해야함
                              );
                            },
                            child: Text(
                              '전체보기',
                              style: Theme.of(context)
                                  .textTheme
                                  .body3
                                  .copyWith(color: ColorSchemes.orange200),
                            ))
                      ],
                    ),
                    SizedBox(height: 24.h),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: friendRequests.length,
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
                  Divider(
                    thickness: 2.h,
                    height: 2.h,
                    color: ColorSchemes.gray100,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                    child: Column(
                      children: [
                        SizedBox(height: 32.h),
                    Row(
                      children: [
                        Text(
                          '알 수도 있는 사람',
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
                      itemCount: friendRequests.length,
                      itemBuilder: (context, index) {
                        final friend = friendRequests[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == friendRequests.length - 1 ? 0 : 24.h,
                          ),
                          child: AddFriendProfile(
                            userName: friend['userName']!,
                            userId: friend['userId']!,
                            time: friend['time']!,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 84.h),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
