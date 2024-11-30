import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/providers/auth_provider.dart'
    as modakbul_auth_provider;
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/firebase_auth_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/string_utils.dart';
import 'package:modakbul/utils/validators.dart';
import 'package:modakbul/widgets/auth_text_form_field.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:provider/provider.dart';

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
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  String? _errorMessage;
  late modakbul_auth_provider.AuthProvider authProvider;
  Timer? _resendTimer;
  int _resendTime = 30; // 타이머 시간을 초 단위로 설정합니다.
  bool _canResend = false;

  _handleButtonPress() {
    if (_codeController.text.isEmpty) {
      return;
    }
    _firebaseAuthService.verifyVerificationCode(
        _codeController.text, onSignInSuccess, onSignInFailure);
    FocusScope.of(context).requestFocus(_codeFocusNode);
  }

  void _validateForm() {
    setState(() {
      /// 버튼 활성화 여부 설정
      _isButtonEnabled =
          _codeController.text.length >= AppConstants.verificationCodeLength &&
              _formKey.currentState?.validate() == true;
      _errorMessage = null;
    });
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTime = 30; // 초기화
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTime > 0) {
        setState(() {
          _resendTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  _resendCode() {
    FirebaseAuthService().sendVerificationCode(
        StringUtils().removeHyphens(authProvider.phoneNumber)!,
        onSignInSuccess,
        onSignInFailure);
    _startResendTimer(); // 타이머를 다시 시작합니다.
  }

  void onSignInSuccess() {
    Routes.navigateReplacement(context, Routes.authNameScreen);

    ///하이픈(-) 제거 후 갱신
    authProvider.phoneNumber =
        StringUtils().removeHyphens(authProvider.phoneNumber);
  }

  void onSignInFailure(String errorCode) {
    String errorMessage;
    switch (errorCode) {
      case 'invalid-verification-code':
        errorMessage = '인증번호가 일치하지 않습니다.';
        break;
      /* case 'expired-action-code':
        errorMessage = '인증번호가 만료 되었습니다.';
        break; */
      case 'user-disabled':
        errorMessage = '사용자 계정이 비활성화 되었습니다.';
        break;
      default:
        errorMessage = '알 수 없는 오류가 발생했습니다.';
    }

    setState(() {
      _errorMessage = errorMessage;
    });
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<modakbul_auth_provider.AuthProvider>(context,
        listen: false);
    _codeController.addListener(_validateForm);
    _firebaseAuthService.sendVerificationCode(
        StringUtils().removeHyphens(authProvider.phoneNumber)!,
        onSignInSuccess,
        onSignInFailure);
    _startResendTimer();
  }

  @override
  void dispose() {
    _codeController.dispose()
    ;_resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        Text('${authProvider.phoneNumber}으로 인증번호를 발송했습니다.',
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
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) => _validateForm(),
                          validator: (value) =>
                              Validators().codeValidator(value, _errorMessage),
                          textEditingController: _codeController,
                          maxLength: AppConstants.verificationCodeLength,
                          focusNode: _codeFocusNode,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: _canResend ? _resendCode : null,
                      child: Text(
                        _canResend ? '재전송' : '$_resendTime초 후 재전송',
                        style: Theme.of(context)
                            .textTheme
                            .smallHeadLine3
                            .copyWith(color: _canResend ? ColorSchemes.orange100 : ColorSchemes.gray200),
                      )),
                ),
                SizedBox(
                  height: 14.h,
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
