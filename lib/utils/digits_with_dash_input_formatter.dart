import 'package:flutter/services.dart';


class DigitsWithDashInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 입력 값에서 숫자, '-' 문자, 공백을 제외한 다른 문자를 모두 제거
    final newText = newValue.text.replaceAll(RegExp('[^0-9-]'), '');

    // 수정된 텍스트의 커서 위치를 새로운 텍스트에 맞게 조정
    TextSelection newSelection = newValue.selection.copyWith(
      baseOffset: newText.length,
      extentOffset: newText.length,
    );

    // 수정된 텍스트와 커서를 포함한 새 값을 반환
    return newValue.copyWith(text: newText, selection: newSelection);
  }
}