class UserCheck {
  String id;
  String userId;
  String name;
  String phoneNo;
  String profileUrl;
  String status;

  UserCheck({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNo,
    required this.profileUrl,
    required this.status,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory UserCheck.fromJson(Map<String, dynamic> json) {
    return UserCheck(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      phoneNo: json['phoneNo'],
      profileUrl: json['profileUrl'],
      status: json['status'],
    );
  }

  // Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phoneNO': phoneNo,
      'profileUrl': profileUrl,
      'status': status,
    };
  }
}