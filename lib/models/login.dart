class Login {
  final String phoneNo;
  final String fcmToken;

  Login({
    required this.phoneNo,
    required this.fcmToken,
  });

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'phoneNo': phoneNo,
      'fcmToken': fcmToken,
    };
  }
}