import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/digits_with_dash_input_formatter.dart';
import 'package:modakbul/utils/validators.dart';
import 'package:modakbul/widgets/auth_text_form_field.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:provider/provider.dart';

class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final FocusNode _phoneFocusNode = FocusNode();
  late AuthProvider authProvider;

  _handleButtonPress() {
    if (_phoneNumberController.text.isEmpty) {
      return;
    }
    FocusScope.of(context).requestFocus(_phoneFocusNode);
    authProvider.phoneNumber = _phoneNumberController.text;
    Routes.navigateTo(context, Routes.changeNumberCodeScreen);
  }

  void _validateForm() {
    setState(() {
      final text = _phoneNumberController.text;

      /// 백스페이스로 '-'가 지워지는 로직 처리
      if (text.isNotEmpty &&
          text.characters.last == '-' &&
          _phoneNumberController.selection.baseOffset == text.length) {
        _phoneNumberController.text = text.substring(0, text.length - 1);
        _phoneNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: _phoneNumberController.text.length),
        );
      }

      /// 버튼 활성화 여부 설정
      _isButtonEnabled = _phoneNumberController.text.length >=
          AppConstants.minPhoneNumberLength &&
          _formKey.currentState?.validate() == true;
    });
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _phoneNumberController.removeListener(_validateForm);
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
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
                        Text('핸드폰 번호 재설정',
                            style: Theme.of(context)
                                .textTheme
                                .bigHeadLine3
                                .copyWith(color: ColorSchemes.gray500)),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text('번호를 변경하게 되면 기존 번호로 로그인할 수 없습니다.',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.gray200)),
                        SizedBox(
                          height: 78.h,
                        ),
                        AuthTextFormField(
                          textInputType: TextInputType.number,
                          hintText: '010-0000-0000',
                          formatters: [
                            MultiMaskedTextInputFormatter(
                                masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'],
                                separator: '-'),
                            DigitsWithDashInputFormatter(),
                          ],
                          onChanged: (value) => _validateForm(),
                          validator: Validators().phoneNumberValidator,
                          textEditingController: _phoneNumberController,
                          maxLength: AppConstants.maxPhoneNumberLength,
                          focusNode: _phoneFocusNode, // FocusNode 전달
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 56.h,
                  width: double.infinity,
                  child: CustomButton(
                      text: '인증번호 받기',
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

