class User {
  String userId;
  String name;
  String phoneNo;
  String profileUrl;
  List<String> fcmToken;
  bool isFriendAlarm;
  bool isContactAgree;

  User({
    required this.userId,
    required this.name,
    required this.phoneNo,
    required this.profileUrl,
    required this.fcmToken,
    required this.isFriendAlarm,
    required this.isContactAgree
  });

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        phoneNo = json['phoneNo'],
        profileUrl = json['profileUrl'],
        fcmToken = List<String>.from(json['fcmToken']),
        isFriendAlarm = json['isFriendAlarm'],
        isContactAgree = json['isContactAgree'];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phoneNo': phoneNo,
      'profileUrl': profileUrl,
      'fcmToken': fcmToken,
      'isFriendAlarm': isFriendAlarm,
      'isContactAgree': isContactAgree
    };
  }

  @override
  String toString() {
    return 'User(userId: $userId, name: $name, phoneNo: $phoneNo, profileUrl: $profileUrl, fcmToken: $fcmToken, isFriendAlarm: $isFriendAlarm, isContactAgree: $isContactAgree)';
  }
}