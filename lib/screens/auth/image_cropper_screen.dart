import 'dart:typed_data';

import 'package:cropperx/cropperx.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

import 'package:modakbul/models/edit_my_profile.dart';

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
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        /*imageQuality: 85, // 이미지 품질 설정 넣어야함?*/
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageCropperScreen(),
            settings: RouteSettings(arguments: imageBytes),
          ),
        );
      }
  }

  Future<String> _uploadImageToServer(Uint8List imageBytes) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageBytes,
          filename: 'profile_image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final dio = Dio();
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
      };

      final response = await dio.post(
        'YOUR_API_ENDPOINT/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['imageUrl'];
      } else {
        throw Exception('업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('이미지 업로드 중 오류 발생: $e');
    }
  }

  Future<void> updateProfileImage(Uint8List imageBytes) async {
    try {

      final String uploadedImageUrl = await _uploadImageToServer(imageBytes);

      await _userService.updateMyProfile(
        EditMyProfile(
          profileUrl: uploadedImageUrl,  // String URL 사용
        ),
      );

      // 3. 로컬 상태 업데이트
      authProvider.profileImage = imageBytes;
      authProvider.isDefaultProfile = false;

      if (!context.mounted) return;

      // 성공 처리
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 이미지가 변경되었습니다.')),
      );

    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 업데이트에 실패했습니다: ${e.toString()}')),
      );
    }
  }

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
