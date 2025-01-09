import 'dart:ffi';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/validators.dart';
import 'package:modakbul/widgets/auth_text_form_field.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/models/edit_my_profile.dart';
import 'package:modakbul/services/user_service.dart';

import '../main.dart';
import 'custom_toast.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final String hintText;
  final bool isName;

  const EditProfileBottomSheet(
      {Key? key, required this.hintText, this.isName = true})
      : super(key: key);

  factory EditProfileBottomSheet.name({
    required String hintText,
  }) =>
      EditProfileBottomSheet(
        hintText: hintText,
        isName: true,
      );

  factory EditProfileBottomSheet.id({
    required String hintText,
  }) =>
      EditProfileBottomSheet(
        hintText: hintText,
        isName: false,
      );

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;

  void _validateForm() {
    setState(() {
      if (widget.isName) {
        _isButtonEnabled = _textEditingController.text.length >=
                AppConstants.minUserNameLength &&
            _formKey.currentState?.validate() == true;
      } else {
        _isButtonEnabled = _textEditingController.text.length >=
                AppConstants.minUserIdLength &&
            _formKey.currentState?.validate() == true;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.addListener(_validateForm);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    _textEditingController.removeListener(_validateForm);
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: ColorSchemes.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(StyleConstants.radiusLarge)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: StyleConstants.defaultPadding,
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 28.r,
                        height: 28.r,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset(
                            IconPath.close,
                            width: 14.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '수정할 ${widget.isName ? '이름을' : '아이디를'} 입력해주세요.',
                    style: Theme.of(context)
                        .textTheme
                        .bigHeadLine3
                        .copyWith(color: ColorSchemes.gray500),
                  ),
                  SizedBox(height: 6.h),
                  Text('${widget.isName ? '이름' : '아이디'} 변경 시 일주일동안 변경할 수 없습니다.',
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: ColorSchemes.gray200)),
                  SizedBox(height: 28.h),
                  AuthTextFormField.bigHeadLine2(
                      textInputType: TextInputType.text,
                      hintText: widget.hintText,
                      onChanged: (value) => _validateForm(),
                      validator: widget.isName
                          ? Validators().userNameValidator
                          : (value) =>
                              Validators().userIdValidator(value, _errorMessage),
                      textEditingController: _textEditingController,
                      maxLength: widget.isName
                          ? AppConstants.maxUserNameLength
                          : AppConstants.maxUserIdLength,
                      focusNode: _focusNode),
                  SizedBox(height: 18.h),
                  SizedBox(
                    height: 56.h,
                    width: double.infinity,
                    child: CustomButton(
                        text: '다음',
                        onPressed: _isButtonEnabled
                            ? () async {
                          try {
                            final EditMyProfile editProfile = EditMyProfile(
                              name: widget.isName ? _textEditingController.text : null,
                              userId: !widget.isName ? _textEditingController.text : null,
                            );

                            final userService = UserService();
                            await userService.updateMyProfile(editProfile);
                            if (widget.isName) {
                              await prefs.setString(AppConstants.userName,
                                  _textEditingController.text);
                            } else {
                              await prefs.setString(AppConstants.userId,
                                  _textEditingController.text);
                            }
                            Navigator.pop(context, true);
                            CustomToast.showToast(context, '프로필이 변경되었습니다.', false);
                          } on DioException catch (e) {
                            String errorMessage = '프로필 수정에 실패했습니다';
                            if (e.response?.statusCode == 404) {
                              errorMessage = 'API 경로를 찾을 수 없습니다';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
                        }
                            : null,
                        buttonColor: ColorSchemes.orange200,
                        textStyle: Theme.of(context).textTheme.smallHeadLine2,
                        textColor: ColorSchemes.white
                    ),
                  ),
                  SizedBox(height: 16.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
