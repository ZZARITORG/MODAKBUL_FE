class StringUtils {

  ///하이픈(-) 제거 함수
  String? removeHyphens(String? input) {
    if (input == null) {
      return null; // input이 null이면 null 반환
    }
    return input.replaceAll(RegExp(r'-'), ''); // input에서 하이픈 제거
  }
}