class UserList {
  final String id;
  final String userId;
  final String name;
  final String profileUrl;

  UserList({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
  });

  // JSON 데이터를 객체로 변환하는 factory 생성자
  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
    );
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'profileUrl': profileUrl,
    };
  }

  @override
  String toString() {
    return 'UserList{id: $id, userId: $userId, name: $name, profileUrl: $profileUrl}';
  }
}

