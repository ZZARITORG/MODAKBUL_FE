import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';
import 'package:modakbul/widgets/add_friend_profile.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FriendService friendService = FriendService();
  List<FriendReqList> friendRequests = [];
  late Future<List<FriendReqList>> getData;
  late DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    getData = friendService.getFriendReqList();// 비동기 메서드 호출
    _updateKoreaTime();
  }

  // 비동기 메서드를 따로 분리
  Future<void> _updateKoreaTime() async {
    currentTime = await DateTimeUtils.getKoreaTime();
    setState(() {});  // currentTime을 업데이트하고 화면을 리빌드
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static String timeAgo(DateTime dateTime, DateTime currentTime) {
    Duration difference = currentTime.difference(dateTime); // 시간 차이 계산

    if (difference.inDays > 0) {
      // 하루 이상 차이 나면 "몇 일 전" 형태로 출력
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      // 한 시간 이상 차이 나면 "몇 시간 전" 형태로 출력
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      // 1분 이상 차이 나면 "몇 분 전" 형태로 출력
      return '${difference.inMinutes}분 전';
    } else {
      // 1분 이내로 차이가 나면 "방금 전" 형태로 출력
      return '방금 전';
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    '친구요청',
                    style: Theme.of(context)
                        .textTheme
                        .bigHeadLine4
                        .copyWith(color: ColorSchemes.gray500),
                  ),
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
                      return Column(
                        children: [
                          SizedBox(height: 144.h),
                          Center(
                            child: Text(
                              '아직 친구가 없어요',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bigHeadLine3
                                  .copyWith(color: ColorSchemes.orange100),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Center(
                            child: Text(
                              '친구를 추가하고 모닥불을 피워보세요',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(color: ColorSchemes.gray300),
                            ),
                          ),
                          SizedBox(height: 28.h),
                        ],
                      ); // 데이터가 없을 때 표시
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
                              profileImage: friend.profileUrl,
                              userName: friend.name,
                              userId: friend.userId,
                              time: timeAgo(friend.createdAt, currentTime),
                              acceptOnPressed: () async {
                                await friendService.acceptFriend(
                                    Uuid(targetId: friend.id));
                                setState(() {
                                  friendRequests.removeWhere((
                                      request) => request.id == friend.id);
                                });
                              },
                              rejectOnPressed: () async {
                                await friendService.rejectFriend(
                                    Uuid(targetId: friend.id));
                                setState(() {
                                  friendRequests.removeWhere((
                                      request) => request.id == friend.id);
                                });
                              },
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
        ],
      ),
    );
  }
}
