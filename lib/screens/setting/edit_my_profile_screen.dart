import 'package:flutter/material.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/screens/modakbul/map_select_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/utils/validators.dart';
import 'package:modakbul/widgets/auth_text_form_field.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

class EditMyProfileScreen extends StatefulWidget {
  const EditMyProfileScreen({super.key});

  @override
  State<EditMyProfileScreen> createState() => _EditMyProfileScreenState();
}

class _EditMyProfileScreenState extends State<EditMyProfileScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final FocusNode _userNameFocusNode = FocusNode();
  final TextEditingController _userIdController = TextEditingController();
  final GlobalKey<FormState> _idFormKey = GlobalKey<FormState>();
  final FocusNode _userIdFocusNode = FocusNode();

  @override
  void dispose() {
    _userNameFocusNode.dispose();
    _userNameController.dispose();
    _userIdController.dispose();
    _userIdFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      /// 버튼 활성화 여부 설정
      _isButtonEnabled =
          _userNameController.text.length >= AppConstants.minUserNameLength &&
              _nameFormKey.currentState?.validate() == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 42.h),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(radius: StyleConstants.circleSizeXXL),
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  backgroundColor: ColorSchemes.orange100,
                                  radius: StyleConstants.circleSizeXS,
                                  child: SvgPicture.asset(
                                      IconPath.photoCameraOrange100,
                                      width: 23.06.r),
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
                      SizedBox(height: 14.h),
                      AuthTextFormField.bigHeadLine2(
                        textInputType: TextInputType.text,
                        hintText: '이름',
                        onChanged: (value) => _validateForm(),
                        validator: Validators().userNameValidator,
                        textEditingController: _userNameController,
                        maxLength: AppConstants.maxUserNameLength,
                        focusNode: _userNameFocusNode, // FocusNode 전달
                      ),
                      SizedBox(height: 32.h),
                      Text('아이디',
                          style: Theme.of(context)
                              .textTheme
                              .smallHeadLine3
                              .copyWith(color: ColorSchemes.orange200)),
                      SizedBox(height: 14.h),
                      AuthTextFormField.bigHeadLine2(
                        textInputType: TextInputType.text,
                        hintText: '아이디',
                        onChanged: (value) => _validateForm(),
                        validator: Validators().userNameValidator,
                        textEditingController: _userIdController,
                        maxLength: AppConstants.maxUserIdLength,
                        focusNode: _userIdFocusNode, // FocusNode 전달
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 56.h,
                  width: double.infinity,
                  child: CustomButton(
                      text: '변경완료',
                      onPressed: () {},
                      buttonColor: ColorSchemes.orange200,
                      textStyle: Theme.of(context).textTheme.smallHeadLine2,
                      textColor: ColorSchemes.white)),
              SizedBox(height: 16.h)
            ],
          ),
        ),
      ),
    );
  }
}
