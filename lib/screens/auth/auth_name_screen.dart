import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/validators.dart';
import 'package:modakbul/widgets/auth_text_form_field.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';

class AuthNameScreen extends StatefulWidget {
  const AuthNameScreen({super.key});

  @override
  State<AuthNameScreen> createState() => _AuthNameScreenState();
}

class _AuthNameScreenState extends State<AuthNameScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final FocusNode _userNameFocusNode = FocusNode();

  _handleButtonPress() {
    if (_userNameController.text.isEmpty) {
      return;
    }
    FocusScope.of(context).requestFocus(_userNameFocusNode);
    Routes.navigateTo(context, Routes.authIdScreen, arguments: _userNameController.text);
  }

  @override
  void dispose() {
    _userNameFocusNode.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      /// 버튼 활성화 여부 설정
      _isButtonEnabled = _userNameController.text.length >=
          AppConstants.minUserNameLength &&
          _formKey.currentState?.validate() == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 42.h,
                      ),
                      Text('이름을 입력해주세요',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine3
                              .copyWith(color: ColorSchemes.gray500)),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text('이름은 공개되며 변경할 수 없습니다.',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: ColorSchemes.gray200)),
                      SizedBox(
                        height: 78.h,
                      ),
                      AuthTextFormField(
                        textInputType: TextInputType.text,
                        hintText: '이름',
                        onChanged: (value) => _validateForm(),
                        validator: Validators().userNameValidator,
                        textEditingController: _userNameController,
                        maxLength: AppConstants.maxUserNameLength,
                        focusNode: _userNameFocusNode, // FocusNode 전달
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 56.h,
                width: double.infinity,
                child: CustomButton(
                    text: '다음',
                    onPressed: _isButtonEnabled ? _handleButtonPress : null,
                    buttonColor: ColorSchemes.orange200,
                    textStyle: Theme.of(context).textTheme.smallHeadLine2,
                    textColor: ColorSchemes.white),
              ),
              SizedBox(
                height: 16.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
