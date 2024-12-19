class FriendReqList {
  final String id;
  final String userId;
  final String name;
  final String profileUrl;

  FriendReqList({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
  });

  factory FriendReqList.fromJson(Map<String, dynamic> json) {
    return FriendReqList(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'profileUrl': profileUrl,
    };
  }
}