import 'dart:typed_data';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:modakbul/services/aws_service.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/models/edit_my_profile.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/widgets/custom_toast.dart';

///TODO: 안드로이드, ios 권한설정 필요 시 dart.io import
class ImageCropperSettingScreen extends StatefulWidget {
  const ImageCropperSettingScreen({super.key});

  @override
  State<ImageCropperSettingScreen> createState() => _ImageCropperSettingScreenState();
}

class _ImageCropperSettingScreenState extends State<ImageCropperSettingScreen> {
  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');
  final OverlayType _overlayType = OverlayType.circle;
  late AuthProvider authProvider;
  AwsService awsService = AwsService();
  UserService userService = UserService();
  bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Uint8List? imageToCrop =
    ModalRoute.of(context)?.settings.arguments as Uint8List?;
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: Cropper(
                overlayType: _overlayType,
                cropperKey: _cropperKey,
                image: Image.memory(imageToCrop!),
                onScaleStart: (details) {
                  // todo: define started action.
                },
                onScaleUpdate: (details) {
                  // todo: define updated action.
                },
                onScaleEnd: (details) {
                  // todo: define ended action.
                },
              ),
            ),
            Positioned(
                bottom: 16.h,
                left: 16.h,
                right: 16.h,
                child: SizedBox(
                  height: 56.h,
                  child: CustomButton(
                      text: '이미지 수정하기',
                      onPressed: _isButtonEnabled ? () async {
                        setState(() {
                          _isButtonEnabled = false;
                        });
                        try {
                        Uint8List? imageBytes = await Cropper.crop(
                          cropperKey: _cropperKey,
                        );
                        if (imageBytes != null) {
                          String imageUrl = await awsService.uploadProfileImage(imageBytes);

                          await userService.updateMyProfile(EditMyProfile(profileUrl: imageUrl));
                          await prefs.setString(AppConstants.profileUrl, imageUrl);
                          //마운트 체크
                          if (!context.mounted) return;
                          Navigator.pop(context,true);
                          CustomToast.showToast(context, '프로필 이미지가 변경되었습니다.', false);
                        }
                      } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('이미지 업데이트 실패: ${e.toString()}')),
                          );
                          setState(() {
                            _isButtonEnabled = true;
                          });
                        }
                      } : null,

                      buttonColor: ColorSchemes.orange200,
                      textStyle: Theme.of(context).textTheme.smallHeadLine2,
                      textColor: ColorSchemes.white),
                ))
          ],
        ),
      ),
    );
  }
}
