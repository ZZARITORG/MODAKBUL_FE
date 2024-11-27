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

class AuthCodeScreen extends StatefulWidget {
  const AuthCodeScreen({super.key});

  @override
  State<AuthCodeScreen> createState() => _AuthCodeScreenState();
}

class _AuthCodeScreenState extends State<AuthCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final FocusNode _codeFocusNode = FocusNode();

  _handleButtonPress() {
    // no nickname
    if (_codeController.text.isEmpty) {
      return;
    }
    FocusScope.of(context).requestFocus(_codeFocusNode);
    Routes.navigateReplacement(context, Routes.authNameScreen);
  }

  void _validateForm() {
    setState(() {
      final text = _codeController.text;

      /// 버튼 활성화 여부 설정
      _isButtonEnabled = _codeController.text.length >=
          AppConstants.verificationCodeLength &&
          _formKey.currentState?.validate() == true;
    });
  }

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SafeArea(
        child: Padding(
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
                        Text('인증번호를 입력해주세요',
                            style: Theme.of(context)
                                .textTheme
                                .bigHeadLine3
                                .copyWith(color: ColorSchemes.gray500)),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text('$phoneNumber으로 인증번호를 발송했습니다.',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.gray200)),
                        SizedBox(
                          height: 78.h,
                        ),
                        AuthTextFormField(
                          textInputType: TextInputType.number,
                          hintText: '인증번호',
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) => _validateForm(),
                          validator: Validators().codeValidator,
                          textEditingController: _codeController,
                          maxLength: AppConstants.verificationCodeLength,
                          focusNode: _codeFocusNode,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 56.h,
                  width: double.infinity,
                  child: CustomButton(
                      text: '인증 완료',
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
      ),
    );
  }
}
