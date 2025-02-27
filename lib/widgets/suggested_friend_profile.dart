import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/themes/color_schemes.dart';

class SuggestedFriendProfile extends StatefulWidget {
  final String? profileImage;
  final String userName;
  final String mutualFriendCount;
  final String userId;
  final UserCheck userCheckData;
  final Function(String) onFriendStatusChanged;
  final VoidCallback onReject;
  final Future<void> Function(Uuid) requestFriend;
  final Future<void> Function(Uuid) deleteFriend;

  const SuggestedFriendProfile({
    Key? key,
    this.profileImage,
    required this.userName,
    required this.mutualFriendCount,
    required this.userId,
    required this.userCheckData,
    required this.onFriendStatusChanged,
    required this.onReject,
    required this.requestFriend,
    required this.deleteFriend,
  }) : super(key: key);

  @override
  State<SuggestedFriendProfile> createState() => _SuggestedFriendProfileState();
}

class _SuggestedFriendProfileState extends State<SuggestedFriendProfile> {
  late ValueNotifier<String> _statusNotifier;

  @override
  void initState() {
    super.initState();
    _statusNotifier = ValueNotifier<String>(widget.userCheckData.status);
  }

  @override
  void dispose() {
    _statusNotifier.dispose();
    super.dispose();
  }

  Future<void> handleAcceptPress() async {
    final currentStatus = _statusNotifier.value;
    try {
      if (currentStatus == 'PENDING') {
        await widget.deleteFriend(Uuid(targetId: widget.userId));
        _statusNotifier.value = 'NONE';
      } else {
        await widget.requestFriend(Uuid(targetId: widget.userId));
        _statusNotifier.value = 'PENDING';
      }
      widget.onFriendStatusChanged(_statusNotifier.value);
    } catch (e) {
      // 에러 처리
      print('친구 상태 변경 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: StyleConstants.circleSizeL,
          child: ClipOval(
              child: CachedNetworkImage(imageUrl: widget.profileImage!)),
          backgroundColor: ColorSchemes.gray200,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  widget.userName,
                  style: Theme.of(context)
                      .textTheme
                      .smallHeadLine3
                      .copyWith(color: ColorSchemes.gray500),
                ),
              ),
              SizedBox(height: 2.h),
              if (widget.mutualFriendCount != '0')
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    '함께 아는 친구 ${widget.mutualFriendCount}명',
                    style: Theme.of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.gray300),
                  ),
                ),
              SizedBox(height: 9.h),
              ValueListenableBuilder<String>(
                valueListenable: _statusNotifier,
                builder: (context, status, child) {
                  String buttonText = status == 'PENDING' ? '취소' : '친구 추가';
                  Color buttonColor = status == 'PENDING'
                      ? ColorSchemes.orange100
                      : ColorSchemes.orange200;
                  return Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: CustomButton(
                            text: buttonText,
                            onPressed: handleAcceptPress,
                            buttonColor: buttonColor,
                            textStyle: Theme.of(context).textTheme.body3,
                            textColor: ColorSchemes.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: CustomButton(
                            text: '삭제',
                            onPressed: widget.onReject,
                            buttonColor: ColorSchemes.gray100,
                            textStyle: Theme.of(context).textTheme.body3,
                            textColor: ColorSchemes.gray400,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}