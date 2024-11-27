import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/lower_case_text_formatter.dart';
import 'package:modakbul/utils/validators.dart';
import 'package:modakbul/widgets/auth_text_form_field.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';


class AuthIdScreen extends StatefulWidget {
  const AuthIdScreen({super.key});

  @override
  State<AuthIdScreen> createState() => _AuthIdScreenState();
}

class _AuthIdScreenState extends State<AuthIdScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final FocusNode _userIdFocusNode = FocusNode();

  _handleButtonPress() {
    if (_userIdController.text.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();

    // 화면 전환 후에 포커스를 설정해 키보드를 올림
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_userIdFocusNode);
    });

    Routes.navigateTo(context, Routes.termsAgreementScreen, arguments: _userIdController.text);
  }

  @override
  void initState() {
    super.initState();
    _userIdController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _userIdFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      /// 버튼 활성화 여부 설정
      _isButtonEnabled = _userIdController.text.length >=
          AppConstants.minUserIdLength &&
          _formKey.currentState?.validate() == true;
    });
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
                        Text('아이디를 입력해주세요',
                            style: Theme.of(context)
                                .textTheme
                                .bigHeadLine3
                                .copyWith(color: ColorSchemes.gray500)),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text('4자~16자 사이의 영문, 숫자를 조합해주세요.', ///특수기호 (., _)도 가능하다는 문구로 변경
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.gray200)),
                        SizedBox(
                          height: 78.h,
                        ),
                        AuthTextFormField(
                          textInputType: TextInputType.text,
                          hintText: '아이디',
                          formatters: [
                            LowerCaseTextFormatter(),
                          ],
                          onChanged: (value) => _validateForm(),
                          validator: Validators().userIdValidator,
                          textEditingController: _userIdController,
                          maxLength: AppConstants.maxUserIdLength,
                          focusNode: _userIdFocusNode,
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
      ),
    );
  }
}
