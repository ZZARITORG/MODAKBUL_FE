class Logout {
  final String fcmToken;

  Logout({required this.fcmToken});

  Map<String, dynamic> toJson() {
    return {
      'fcmToken': fcmToken,
    };
  }
}