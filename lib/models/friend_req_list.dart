class FriendReqList {
  final String id;
  final String userId;
  final String name;
  final String profileUrl;
  final DateTime timestamp; // timestamp 필드 추가

  FriendReqList({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
    required this.timestamp, // timestamp 생성자에 추가
  });

  factory FriendReqList.fromJson(Map<String, dynamic> json) {
    return FriendReqList(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String), // timestamp를 DateTime으로 변환
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'profileUrl': profileUrl,
      'timestamp': timestamp.toIso8601String(), // DateTime을 ISO 8601 형식의 문자열로 변환
    };
  }
}