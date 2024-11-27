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
  final bool isBigHeadLine2;

  const AuthTextFormField(
      {Key? key,
      this.isBigHeadLine2 = false,
      required this.textInputType,
      required this.hintText,
      required this.onChanged,
      required this.validator,
      required this.textEditingController,
      required this.maxLength,
      required this.focusNode,
      this.formatters})
      : super(key: key);

  factory AuthTextFormField.bigHeadLine2({
    required TextInputType textInputType,
    required String hintText,
    required ValueChanged<String>? onChanged,
    required FormFieldValidator<String>? validator,
    required TextEditingController textEditingController,
    required int maxLength,
    required FocusNode focusNode,
    List<TextInputFormatter>? formatters,
  }) =>
      AuthTextFormField(
          isBigHeadLine2: true,
          textInputType: textInputType,
          hintText: hintText,
          onChanged: onChanged,
          validator: validator,
          textEditingController: textEditingController,
          maxLength: maxLength,
          focusNode: focusNode);

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // FocusNode 리스너 추가
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    // FocusNode 리스너 제거
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      // Focus 상태가 변경되면 UI 업데이트
    });
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
    } else if (widget.focusNode.hasFocus) {
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
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(widget.focusNode);
                });
              },
              onTapOutside: (event) {
                setState(() {
                  widget.focusNode.unfocus();
                });
              },
              cursorColor: ColorSchemes.orange100,
              style: widget.isBigHeadLine2 ? Theme.of(context)
                  .textTheme
                  .bigHeadLine2
                  .copyWith(color: ColorSchemes.gray500) : Theme.of(context)
                  .textTheme
                  .bigHeadLine1
                  .copyWith(color: ColorSchemes.gray500),
              decoration: InputDecoration(
                counterText: '',
                hintText: widget.hintText,
                hintStyle: widget.isBigHeadLine2 ? Theme.of(context)
                    .textTheme
                    .bigHeadLine2
                    .copyWith(color: ColorSchemes.gray200) : Theme.of(context)
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
                height: 2.h,
                decoration: BoxDecoration(
                    color: underlineColor,
                    borderRadius: BorderRadius.circular(2.r)),
              ),
            ),
          ],
        ),
        if (_hasError && _errorText != null) ...[
          SizedBox(height: widget.isBigHeadLine2 ? 8.h : 10.h),
          SizedBox(width: 4.w,),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(_errorText!.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: ColorSchemes.red)),
          ),
        ]
      ],
    );
  }
}
