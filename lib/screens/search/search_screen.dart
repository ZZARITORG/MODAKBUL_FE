import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/models/user_list.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/participant_list_profile.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/widgets/custom_search_bar.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, String>> selectedFriends = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  UserService userService = UserService();
  List<UserList> userList = [];
  late Future<List<UserList>> getData;

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSelectGroup(
      String userId, String userName, String profilePicture) {
    setState(() {
      final friend = {
        'userId': userId,
        'userName': userName,
        'profilePicture': profilePicture,
      };

      /// 이미 선택된 친구인지 확인하여 추가 또는 제거
      if (selectedFriends.any((friend) => friend['userId'] == userId)) {
        selectedFriends.removeWhere((friend) => friend['userId'] == userId);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              CustomSearchBar(
                hintText: '사용자를 검색해보세요.',
                controller: _searchController,
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Row(
                  children: [
                    Text(
                      '검색결과',
                      style: Theme.of(context)
                          .textTheme
                          .bigHeadLine4
                          .copyWith(color: ColorSchemes.gray500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Expanded(
                  child: FutureBuilder<List<UserList>>(
                    future: getData,  // 서버에서 가져오는 비동기 데이터
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // 데이터를 기다리는 동안 로딩 화면 표시
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // 에러가 있을 경우 에러 메시지 표시
                        return Center(child: Text('오류 발생: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // 데이터가 없을 경우
                        return Column(
                          children: [
                            SizedBox(height: 118.h),
                            Text(
                              '검색 결과가 없습니다.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bigHeadLine3
                                  .copyWith(color: ColorSchemes.orange100), // 올바른 스타일 적용
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '검색어를 다시 확인해 주세요',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(color: ColorSchemes.gray300),
                            ),
                          ],
                        );
                      } else { // 데이터가 있을 경우 ListView.builder로 리스트 생성
                        userList = snapshot.data!; // 서버에서 받아온 데이터 리스트
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: userList.length, // 받아온 데이터의 길이를 사용
                          itemBuilder: (BuildContext context, int index) {
                            final user = userList[index];
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                final selectedUser = userList[index];
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(24),
                                          topRight: Radius.circular(24),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 24.h),
                                          Padding(
                                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                    IconPath.moreHorizontal,
                                                    width: 20.w,
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                ),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                    IconPath.arrowDown,
                                                    width: 18.w,
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 18.h),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20.h, right: 24.h),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        selectedUser.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bigHeadLine2
                                                            .copyWith(color: ColorSchemes.gray500),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Text(
                                                        selectedUser.userId,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .body2
                                                            .copyWith(color: ColorSchemes.gray300),
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      Text(
                                                        '함께하는 친구가 10명 있습니다!',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .body3
                                                            .copyWith(color: ColorSchemes.gray200),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 37.w), // 고정 간격 추가
                                                CircleAvatar(
                                                  radius: StyleConstants.circleSizeL,
                                                  backgroundImage: NetworkImage(selectedUser.profileUrl),
                                                  backgroundColor: ColorSchemes.gray500,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 32.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 56.h,
                                              child: CustomButton(
                                                  text: '친구수락',
                                                  onPressed: () {},
                                                  buttonColor: ColorSchemes.orange200,
                                                  textStyle: Theme.of(context).textTheme.smallHeadLine2,
                                                  textColor: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 56.h),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              onTapDown: (_) {},
                              child: Participantlistprofile(
                                userName: user.name,
                                userId: user.userId,
                                profileImage: user.profileUrl,
                              ),
                            );
                          },
                        );
                      }
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
