class MyProfile {
  final String id;
  final String userId;
  final String userName;
  final String phoneNumber;
  final String profileUrl;
  final List<String> fcmToken;
  final String createdAt;
  final String? updatedAt;
  final bool? isContactAgree;
  final bool? isFriendAlarm;

  MyProfile({
    required this.id,
    required this.userId,
    required this.userName,
    required this.phoneNumber,
    required this.profileUrl,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
    this.isContactAgree,
    this.isFriendAlarm
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) {
    return MyProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['name'] as String,
      phoneNumber: json['phoneNo'] as String,
      profileUrl: json['profileUrl'] as String,
      fcmToken: List<String>.from(json['fcmToken'] ?? []),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      isContactAgree: json['isContactAgree'] as bool?,
      isFriendAlarm: json['isFriendAlarm'] as bool?
    );
  }
}