import 'package:flutter/material.dart';
import 'package:modakbul/main.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final Color textColor;
  final TextStyle textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonColor,
    required this.textStyle,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style!.copyWith(// 기본값 0
        backgroundColor:  WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Theme.of(context).primaryColorLight; // 비활성화 상태일 때의 배경색
          }
          return buttonColor; // 기본 배경색
        }), // 버튼 색상 적용
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle.copyWith(color: textColor),
      ),
    );
  }
}
