import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/user_check.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/services/friend_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class ProfileBottomSheet extends StatefulWidget {
  final UserCheck userCheckData;
  final String selectedUserId;
  final FriendService friendService;
  final Function(String)? onFriendStatusChanged;

  const ProfileBottomSheet({
    Key? key,
    required this.userCheckData,
    required this.selectedUserId,
    required this.friendService,
    this.onFriendStatusChanged,
  }) : super(key: key);

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  bool _isButtonDisabled = false;

  void _handleStatusChange(BuildContext context) {
    if (widget.onFriendStatusChanged != null) {
      widget.onFriendStatusChanged!(widget.selectedUserId);
    }
    Navigator.pop(context);
  }

  void _handleFriendRequest(BuildContext context) async {
    if (_isButtonDisabled) return;
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      await widget.friendService
          .requestFriend(Uuid(targetId: widget.selectedUserId));
      _handleStatusChange(context);
    } catch (e) {
    } finally {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isButtonDisabled = false;
          });
        }
      });
    }
  }

  void _handleFriendDeletion(BuildContext context) async {
    if (_isButtonDisabled) return;
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      await widget.friendService
          .deleteFriend(Uuid(targetId: widget.selectedUserId));
      _handleStatusChange(context);
    } catch (e) {
    } finally {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isButtonDisabled = false;
          });
        }
      });
    }
  }

  void _handleFriendAcceptance(BuildContext context) async {
    if (_isButtonDisabled) return;
    setState(() {
      _isButtonDisabled = true;
    });
    try {
      await widget.friendService
          .acceptFriend(Uuid(targetId: widget.selectedUserId));
      _handleStatusChange(context);
    } catch (e) {
    } finally {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isButtonDisabled = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(StyleConstants.radiusLarge),
          topRight: Radius.circular(StyleConstants.radiusLarge),
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
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(StyleConstants.radiusLarge),
                              topRight:
                                  Radius.circular(StyleConstants.radiusLarge),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: StyleConstants.defaultPadding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 38.h),
                              Row(
                                children: [
                                  Text(
                                    widget.userCheckData.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bigHeadLine3
                                        .copyWith(color: ColorSchemes.gray500),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              if (widget.userCheckData.status != 'ACCEPTED' &&
                                  widget.userCheckData.status != 'PENDING') ...[
                                InkWell(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  onTap: _isButtonDisabled
                                      ? null
                                      : () {
                                          _handleFriendRequest(context);
                                        },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('친구추가',
                                          style: Theme.of(context)
                                              .textTheme
                                              .smallHeadLine3
                                              .copyWith(
                                                  color: ColorSchemes.gray300)),
                                      SizedBox(
                                        width: 24.r,
                                        height: 24.r,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            IconPath.arrowForwardGray200,
                                            width: 9.r,
                                            height: 16.r,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),
                              ],
                              InkWell(
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                onTap: () {
                                  widget.friendService
                                      .blockFriend(
                                          Uuid(targetId: widget.selectedUserId))
                                      .then((_) {
                                    _handleStatusChange(context);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('사용자 차단하기',
                                        style: Theme.of(context)
                                            .textTheme
                                            .smallHeadLine3
                                            .copyWith(
                                                color: ColorSchemes.gray300)),
                                    SizedBox(
                                      width: 24.r,
                                      height: 24.r,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          IconPath.arrowForwardGray200,
                                          width: 9.r,
                                          height: 16.r,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                              InkWell(
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('사용자 신고하기',
                                        style: Theme.of(context)
                                            .textTheme
                                            .smallHeadLine3
                                            .copyWith(
                                                color: ColorSchemes.gray300)),
                                    SizedBox(
                                      width: 24.r,
                                      height: 24.r,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          IconPath.arrowForwardGray200,
                                          width: 9.r,
                                          height: 16.r,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 56.h),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: SvgPicture.asset(
                    IconPath.moreHorizontal,
                    width: 20.w,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    IconPath.arrowDown,
                    width: 18.w,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 26.h),
          Padding(
            padding: EdgeInsets.only(left: 20.h, right: 24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.userCheckData.mutualCount == 0)
                        SizedBox(height: 14.h),
                      Text(
                        widget.userCheckData.name,
                        style: Theme.of(context)
                            .textTheme
                            .bigHeadLine2
                            .copyWith(color: ColorSchemes.gray500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.userCheckData.userId,
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: ColorSchemes.gray300),
                      ),
                      SizedBox(height: 6.h),
                      if (widget.userCheckData.mutualCount > 0)
                        Text(
                          '함께하는 친구가 ${widget.userCheckData.mutualCount}명 있습니다!',
                          style: Theme.of(context)
                              .textTheme
                              .body3
                              .copyWith(color: ColorSchemes.gray200),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 37.w),
                CircleAvatar(
                  radius: StyleConstants.circleSizeL,
                  backgroundColor: ColorSchemes.gray200,
                  child: ClipOval(
                      child: CachedNetworkImage(imageUrl: widget.userCheckData.profileUrl)),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: SizedBox(
              width: double.infinity,
              child: widget.userCheckData.status == 'PENDING'
                  ? widget.userCheckData.sourceId == widget.selectedUserId
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: CustomButton(
                                  text: '친구 수락',
                                  onPressed: _isButtonDisabled
                                      ? null
                                      : () {
                                          _handleFriendAcceptance(context);
                                        },
                                  buttonColor: _isButtonDisabled
                                      ? ColorSchemes.gray200
                                      : ColorSchemes.orange200,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .smallHeadLine2,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: SizedBox(
                                height: 56.h,
                                child: CustomButton(
                                  text: '삭제',
                                  onPressed: _isButtonDisabled
                                      ? null
                                      : () {
                                          _handleFriendDeletion(context);
                                        },
                                  buttonColor: ColorSchemes.gray100,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .smallHeadLine2,
                                  textColor: ColorSchemes.gray400,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 56.h,
                          child: CustomButton(
                            text: '요청 취소',
                            onPressed: _isButtonDisabled
                                ? null
                                : () {
                                    _handleFriendDeletion(context);
                                  },
                            buttonColor: _isButtonDisabled
                                ? ColorSchemes.gray200
                                : ColorSchemes.orange100,
                            textStyle:
                                Theme.of(context).textTheme.smallHeadLine2,
                            textColor: Colors.white,
                          ),
                        )
                  : SizedBox(
                      height: 56.h,
                      child: CustomButton(
                        text: widget.userCheckData.status == 'ACCEPTED'
                            ? '친구 삭제'
                            : widget.userCheckData.status == 'PENDING'
                                ? (widget.userCheckData.sourceId ==
                                        widget.selectedUserId
                                    ? '친구 수락'
                                    : '삭제')
                                : '친구 요청',
                        onPressed: _isButtonDisabled
                            ? null
                            : () {
                                switch (widget.userCheckData.status) {
                                  case 'ACCEPTED':
                                    _handleFriendDeletion(context);
                                    break;
                                  case 'REJECTED':
                                  case 'NONE':
                                    _handleFriendRequest(context);
                                }
                              },
                        buttonColor: _isButtonDisabled
                            ? ColorSchemes.orange200
                            : ColorSchemes.orange200,
                        textStyle: Theme.of(context).textTheme.smallHeadLine2,
                        textColor: Colors.white,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 56.h),
        ],
      ),
    );
  }
}
