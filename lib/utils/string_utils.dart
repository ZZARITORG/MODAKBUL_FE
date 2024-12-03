import 'dart:math';

class StringUtils {

  ///하이픈(-) 제거 함수
  String? removeHyphens(String? input) {
    if (input == null) {
      return null; // input이 null이면 null 반환
    }
    return input.replaceAll(RegExp(r'-'), ''); // input에서 하이픈 제거
  }

  String wordBreaks (String input) {
    return input.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D');
  }

  String generateRandomString() {
    final random = Random();
    final randomValue = (random.nextDouble() * 1000000).toInt(); // 큰 정수값 생성
    final base36String = randomValue.toRadixString(36); // 36진수 문자열로 변환
    return base36String; // 변환된 문자열 반환
  }
}