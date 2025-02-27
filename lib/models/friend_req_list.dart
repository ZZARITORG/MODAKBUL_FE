class FriendReqList {
  final String id;
  final String userId;
  final String name;
  final String profileUrl;
  final DateTime createdAt; // 새로운 createdAt 필드 추가
  final DateTime updatedAt;

  FriendReqList({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
    required this.createdAt, // 생성자에서 createdAt 추가
    required this.updatedAt,
  });

  factory FriendReqList.fromJson(Map<String, dynamic> json) {
    return FriendReqList(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String), // createdAt 파싱
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'profileUrl': profileUrl,
      'createdAt': createdAt.toIso8601String(), // createdAt을 ISO 8601 형식으로 변환
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}