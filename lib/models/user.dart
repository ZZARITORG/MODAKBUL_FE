class User {
  String userId;
  String name;
  String phoneNo;
  String profileUrl;
  List<String> fcmToken;

  User({
    required this.userId,
    required this.name,
    required this.phoneNo,
    required this.profileUrl,
    required this.fcmToken,
  });

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        phoneNo = json['phoneNo'],
        profileUrl = json['profileUrl'],
        fcmToken = List<String>.from(json['fcmToken']);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phoneNo': phoneNo,
      'profileUrl': profileUrl,
      'fcmToken': fcmToken,
    };
  }
}