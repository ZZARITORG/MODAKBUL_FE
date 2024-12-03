import 'dart:typed_data';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:provider/provider.dart';

///TODO: 안드로이드, ios 권한설정 필요 시 dart.io import
class ImageCropperScreen extends StatefulWidget {
  const ImageCropperScreen({super.key});

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');
  final OverlayType _overlayType = OverlayType.circle;
  late AuthProvider authProvider;

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
                      text: '이미지 선택하기',
                      onPressed: () async {
                        Uint8List? imageBytes = await Cropper.crop(
                          cropperKey: _cropperKey,
                        );
                        if (imageBytes != null) {
                          authProvider.profileImage = imageBytes;
                          authProvider.isDefaultProfile = false;
                          //마운트 체크
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        }
                      },
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
