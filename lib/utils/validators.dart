class Validators {
  String? phoneNumberValidator(String? value) {
    /// value가 null이거나 비어있는 경우
    if (value == null || value.isEmpty) {
      return null; // 텍스트 필드가 비어있으면 에러 메시지를 반환하지 않음
    }

    /// 숫자와 하이픈만 허용하는 정규식 패턴
    final numberPattern = RegExp(r'^\d{1,3}(-\d{1,4}){0,2}$');

    /// 입력값이 숫자와 하이픈 이외의 문자가 포함된 경우
    if (!numberPattern.hasMatch(value)) {
      return '전화번호는 숫자만 가능합니다.';
    }

    return null;
  }

  String? codeValidator(String? value, String? errorMessage) {
    if (value == null || value.isEmpty) {
      return null; // 텍스트 필드가 비어있으면 에러 메시지를 반환하지 않음
    }

    // 숫자만 허용하는 정규식 패턴
    final numberPattern = RegExp(r'^[0-9]+$');

    if (!numberPattern.hasMatch(value)) {
      return '인증번호는 숫자만 가능합니다.';
    }

    if (errorMessage != null) {
      return errorMessage;
    }

    return null;
  }

  String? userNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final userNamePattern = RegExp(r'^[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]+$');

    final hasOnlyConsonantsAndVowels = RegExp(r'^[ㄱ-ㅎㅏ-ㅣ]+$');

    final hasMixedConsonantsAndSyllables =
    RegExp(r'(?=.*[ㄱ-ㅎ])(?=.*[가-힣])|(?=.*[ㅏ-ㅣ])(?=.*[가-힣])');

    if (!userNamePattern.hasMatch(value)) {
      return '이름은 한글, 영문만 가능합니다. (초성 사용불가)';
    }

    if (hasOnlyConsonantsAndVowels.hasMatch(value)) {
      return '이름은 한글, 영문만 가능합니다. (초성 사용불가)';
    }

    if (hasMixedConsonantsAndSyllables.hasMatch(value)) {
      return '이름은 한글, 영문만 가능합니다. (초성 사용불가)';
    }

    return null;
  }

  String? userIdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null; //
    }

    /// 숫자, 영어 알파벳, 언더스코어(_) 또는 점(.)만 허용하는 정규식
    final userIdPattern = RegExp(r'^[a-zA-Z0-9_.]+$');

    if (!userIdPattern.hasMatch(value)) {
      return '숫자, 영어 알파벳, 언더스코어(_) 또는 점(.)만 입력할 수 있습니다.';
    }

    // Firestore에서 아이디 중복 확인 (여기서는 생략)

    return null;
  }
}