import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/screens/friend/add_freind_screen.dart';
import 'package:modakbul/services/friend_req_service.dart';
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
  FriendReqService friendReqService = FriendReqService();
  List<FriendReqList> friendRequests = [];
  late Future<List<FriendReqList>> getData;

  @override
  void initState() {
    super.initState();
    getData = friendReqService.getFriendReqList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: /*Skeleton 들어갈 자리 */ SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: StyleConstants.defaultPadding),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    CustomSearchBar(
                      hintText: '사용자를 검색해보세요.',
                      controller: _searchController,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SizedBox(width: 4.w),
                        Text(
                          '친구요청',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine4
                              .copyWith(color: ColorSchemes.gray500),
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddFreindScreen()), // AddFreindScreen 으로 이동해야함
                              );
                            },
                            child: Text(
                              '전체보기',
                              style: Theme.of(context)
                                  .textTheme
                                  .body3
                                  .copyWith(color: ColorSchemes.orange200),
                            )),
                        SizedBox(width: 4.w),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    FutureBuilder<List<FriendReqList>>(
                      future: getData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator()); // 로딩 중일 때 표시
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}')); // 에러 발생 시 표시
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No friend requests available.')); // 데이터가 없을 때 표시
                        } else {
                          friendRequests = snapshot.data!;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: friendRequests.length,
                            itemBuilder: (context, index) {
                              final friend = friendRequests[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
                                child: AddFriendProfile(
                                  userName: friend.name!,
                                  userId: friend.userId!,
                                  time: friend.id!,
                                ),
                              );
                            },
                          );
                        }
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
                padding: EdgeInsets.symmetric(
                    horizontal: StyleConstants.defaultPadding),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        SizedBox(width: 4.w),
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
                            bottom:
                                index == friendRequests.length - 1 ? 0 : 24.h,
                          ),
                          child: AddFriendProfile(
                            userName: friend.name!,
                            userId: friend.userId!,
                            time: friend.id!,
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
