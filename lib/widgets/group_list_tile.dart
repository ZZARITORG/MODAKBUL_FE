import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/accepted_modakbul.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class GroupListTile extends StatelessWidget {
  final String title;
  final String time;
  final String? profileImage1;
  final String? profileImage2;
  final int profileLength;
  final bool isSelected;
  final VoidCallback recreateGroup;
  final VoidCallback updateGroup;
  final VoidCallback deleteGroup;

  const GroupListTile(
      {Key? key,
        required this.title,
        required this.time,
        this.profileImage1,
        this.profileImage2,
        required this.profileLength,
        this.isSelected = false,
        required this.recreateGroup,
        required this.updateGroup,
        required this.deleteGroup,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StyleConstants.radiusMedium),
        side: BorderSide(
          color: isSelected ? ColorSchemes.orange200 : Colors.transparent,
          width: 3.0.w,
        ),
      ),
      color: ColorSchemes.white,
      ///clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 42.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 24.r,
              width: 24.r,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(StyleConstants.radiusLarge),
                              topRight: Radius.circular(StyleConstants.radiusLarge),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 38.h),
                                Text(title, style: Theme.of(context).textTheme.bigHeadLine3.copyWith(color: ColorSchemes.gray500)),
                                SizedBox(height: 24.h),
                                InkWell(
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                  onTap: recreateGroup,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('이 그룹으로 모닥불 피우기', style: Theme.of(context).textTheme.smallHeadLine2.copyWith(color: ColorSchemes.gray300)),
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
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                  onTap: updateGroup,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('그룹 수정하기', style: Theme.of(context).textTheme.smallHeadLine2.copyWith(color: ColorSchemes.gray300)),
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
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                  onTap: deleteGroup,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('그룹 삭제하기', style: Theme.of(context).textTheme.smallHeadLine2.copyWith(color: ColorSchemes.gray300)),
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
                          ),
                        );
                      },
                    );
                  },
                  icon: SvgPicture.asset(IconPath.moreHorizontal, fit: BoxFit.scaleDown,)),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .smallHeadLine1
                            .copyWith(color: isSelected ? ColorSchemes.orange200 : ColorSchemes.gray500,),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        time,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: ColorSchemes.orange200),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w,),
                SizedBox(
                  width: 98.r,
                  child: Stack(
                    children: [
                      if (profileLength >= 1)
                        Positioned(
                            child: CircleAvatar(
                              radius: StyleConstants.circleSizeXS,
                              backgroundColor: ColorSchemes.white,
                              child: CircleAvatar(
                                radius: StyleConstants.circleSizeXXXS,
                                backgroundColor: ColorSchemes.orange200,
                                child: ClipOval(
                                    child: CachedNetworkImage(imageUrl: profileImage1!)),
                              ),
                            )),
                      if (profileLength >= 2)
                        Positioned(
                            left: 28.r,
                            child: CircleAvatar(
                              radius: StyleConstants.circleSizeXS,
                              backgroundColor: ColorSchemes.white,
                              child: CircleAvatar(
                                radius: StyleConstants.circleSizeXXXS,
                                backgroundColor: ColorSchemes.orange100,
                                child: ClipOval(
                                    child: CachedNetworkImage(imageUrl: profileImage2!)),
                              ),
                            )),
                      if (profileLength >= 3)
                        Positioned(
                            left: 56.r,
                            child: CircleAvatar(
                              radius: StyleConstants.circleSizeXS,
                              backgroundColor: ColorSchemes.white,
                              child: CircleAvatar(
                                radius: StyleConstants.circleSizeXXXS,
                                backgroundColor: ColorSchemes.gray300,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    '+${profileLength - 2}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body3
                                        .copyWith(color: ColorSchemes.white),
                                  ),
                                ),
                              ),
                            )),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}