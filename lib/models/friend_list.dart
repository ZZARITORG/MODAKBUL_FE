class FriendList {
  final String id;
  final String userId;
  final String userName;
  final String profileUrl;
  final int count;
  final String? updatedAt;

  FriendList({
    required this.id,
    required this.userId,
    required this.userName,
    required this.profileUrl,
    required this.count,
    required this.updatedAt,
  });

  // JSON 데이터를 Dart 객체로 변환하는 factory 생성자
  factory FriendList.fromJson(Map<String, dynamic> json) {
    return FriendList(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      count: json['count'] as int,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  // 객체를 문자열로 출력하기 위해 toString() 메서드 오버라이드
  @override
  String toString() {
    return 'FriendList{id: $id, userId: $userId, userName: $userName, profileUrl: $profileUrl, count: $count, updatedAt: $updatedAt}';
  }
}