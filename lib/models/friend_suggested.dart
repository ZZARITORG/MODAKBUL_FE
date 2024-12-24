class FriendSuggested {
  final String id;
  final String userId;
  final String name;
  final String profileUrl;
  final int mutualFriendCount; // mutualFriendCount 필드

  FriendSuggested({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
    required this.mutualFriendCount, // 생성자에 추가
  });

  // JSON 데이터를 Dart 객체로 변환하는 팩토리 생성자
  factory FriendSuggested.fromJson(Map<String, dynamic> json) {
    return FriendSuggested(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      mutualFriendCount: json['mutualFriendCount'] as int, // mutualFriendCount 파싱
    );
  }

  // Dart 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'profileUrl': profileUrl,
      'mutualFriendCount': mutualFriendCount, // JSON으로 변환 시 mutualFriendCount 포함
    };
  }
}