import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/main.dart';

import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class AuthTextFormField extends StatefulWidget {
  final TextInputType textInputType;
  final List<TextInputFormatter>? formatters;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController textEditingController;
  final int maxLength;
  final FocusNode focusNode; // FocusNode 추가

  const AuthTextFormField(
      {Key? key,
        required this.textInputType,
        required this.hintText,
        required this.onChanged,
        required this.validator,
        required this.textEditingController,
        required this.maxLength,
        required this.focusNode,
        this.formatters})
      : super(key: key);

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
  }

  void _validateInput(String value) {
    final validationError = widget.validator?.call(value);
    setState(() {
      _hasError = validationError != null;
      _errorText = validationError;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color underlineColor;

    if (_hasError) {
      underlineColor = ColorSchemes.orange000;
    } else if (widget.focusNode?.hasFocus ?? false) {
      underlineColor = ColorSchemes.orange200;
    } else {
      underlineColor = ColorSchemes.gray100;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextFormField(
              enableInteractiveSelection: false,
              onChanged: (value) {
                widget.onChanged!(value);
                _validateInput(value);
              },
              autofocus: true,
              maxLength: widget.maxLength,
              validator: widget.validator,
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              // 전달된 FocusNode 사용
              keyboardType: widget.textInputType,
              inputFormatters: widget.formatters,
              textInputAction: TextInputAction.done,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              cursorColor: ColorSchemes.orange100,
              style: Theme.of(context)
                  .textTheme
                  .bigHeadLine1
                  .copyWith(color: ColorSchemes.gray500),
              decoration: InputDecoration(
                counterText: '',
                hintText: widget.hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bigHeadLine1
                    .copyWith(color: ColorSchemes.gray200),
                isDense: true,
                contentPadding: EdgeInsets.only(left: 4.w),
                border: InputBorder.none,
                errorText: null,
                errorStyle:
                const TextStyle(color: ColorSchemes.orange100, fontSize: 0),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 2.w,
                decoration: BoxDecoration(
                    color: underlineColor,
                    borderRadius: BorderRadius.circular(2.r)),
              ),
            ),
          ],
        ),
        if (_hasError && _errorText != null) ...[
          SizedBox(height: 10.h),
          Text(_errorText!,
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.red)),
        ]
      ],
    );
  }
}
