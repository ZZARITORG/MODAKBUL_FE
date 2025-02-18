import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/edit_profile_bottom_sheet.dart';
import 'package:modakbul/models/my_profile.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/utils/image_picker_utils.dart';
import 'package:modakbul/main.dart';
import 'image_cropper_setting_screen.dart';

class EditMyProfileScreen extends StatefulWidget {
  EditMyProfileScreen({super.key});

  @override
  State<EditMyProfileScreen> createState() => _EditMyProfileScreenState();
}

class _EditMyProfileScreenState extends State<EditMyProfileScreen> {
  late Future<MyProfile> _futureProfile;
  UserService userService = UserService();
  ImagePickerUtils imagePickerUtils = ImagePickerUtils();
  XFile? _imageFile;
  String? userId;
  String? userName;
  String? profileUrl;

  @override
  void initState() {
    super.initState();
    userId = prefs.getString(AppConstants.userId);
    userName = prefs.getString(AppConstants.userName);
    profileUrl = prefs.getString(AppConstants.profileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSchemes.gray000,
      appBar: const BackButtonAppBar(backgroundColor: ColorSchemes.gray000,
      returnResult: true),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 42.h),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(radius: StyleConstants.circleSizeXXL,
                              child: ClipOval(
                                  child: CachedNetworkImage(imageUrl: profileUrl!))),
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  backgroundColor: ColorSchemes.orange100,
                                  radius: StyleConstants.circleSizeXS,
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () async {
                                        _imageFile = await imagePickerUtils.pickImage(
                                          ImageSource.gallery,
                                        );
                                        if (_imageFile != null) {
                                          Uint8List? imageBytes = await _imageFile!.readAsBytes();
                                          //마운트 체크
                                          if (!context.mounted) return;
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ImageCropperSettingScreen(),
                                              settings: RouteSettings(arguments: imageBytes),
                                            ),
                                          );

                                          if (result == true) {
                                            setState(() {
                                              profileUrl = prefs.getString(AppConstants.profileUrl);
                                            });

                                          }
                                        }
                                      },
                                       icon: SvgPicture.asset(
                                      IconPath.photoCameraOrange100,
                                      width: 23.06.r))
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 42.h),
                      Text('이름',
                          style: Theme.of(context)
                              .textTheme
                              .smallHeadLine3
                              .copyWith(color: ColorSchemes.orange200)),
                      SizedBox(height: 10.h),
                      InkWell(
                        onTap: () async {
                          final result = await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return EditProfileBottomSheet.name(hintText: userName!);
                              }
                          );

                          if (result == true) {
                            setState(() {
                              userName = prefs.getString(AppConstants.userName);
                            });
                          }
                        },
                        overlayColor:
                        WidgetStateProperty.all(Colors.transparent),
                        child: Column(
                          children: [
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SizedBox(width: 4.w),
                                Text(userName!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bigHeadLine2
                                        .copyWith(color: ColorSchemes.gray200)),
                                const Spacer(),
                                SizedBox(
                                  width: 32.r,
                                  height: 32.r,
                                  child: Center(
                                    child: SvgPicture.asset(IconPath.edit,
                                        width: 27.r),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              height: 2.h,
                              decoration: BoxDecoration(
                                  color: ColorSchemes.gray100,
                                  borderRadius: BorderRadius.circular(2.r)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Text('아이디',
                          style: Theme.of(context)
                              .textTheme
                              .smallHeadLine3
                              .copyWith(color: ColorSchemes.orange200)),
                      SizedBox(height: 10.h),
                      InkWell(
                        onTap: () async {
                          final result = await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return EditProfileBottomSheet.id(hintText: userId!);
                              }
                          );

                          if (result == true) {
                            setState(() {
                              userId = prefs.getString(AppConstants.userId);
                            });
                          }
                        },
                        overlayColor:
                        WidgetStateProperty.all(Colors.transparent),
                        child: Column(
                          children: [
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SizedBox(width: 4.w),
                                Text(userId!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bigHeadLine2
                                        .copyWith(color: ColorSchemes.gray200)),
                                const Spacer(),
                                SizedBox(
                                  width: 32.r,
                                  height: 32.r,
                                  child: Center(
                                    child: SvgPicture.asset(IconPath.edit,
                                        width: 27.r),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              height: 2.h,
                              decoration: BoxDecoration(
                                  color: ColorSchemes.gray100,
                                  borderRadius: BorderRadius.circular(2.r)),
                            ),
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
