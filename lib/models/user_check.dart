class UserCheck {
  final String id;
  final String userId;
  final String name;
  final String phoneNo;
  final String profileUrl;
  late final String status;
  final int mutualCount;
  final String? sourceId;
  final String? targetId;

  UserCheck({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNo,
    required this.profileUrl,
    required this.status,
    required this.mutualCount,
    required this.sourceId,
    required this.targetId,
  });

  // JSON 데이터를 객체로 변환하는 factory 생성자
  factory UserCheck.fromJson(Map<String, dynamic> json) {
    return UserCheck(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      phoneNo: json['phoneNo'] as String,
      profileUrl: json['profileUrl'] as String,
      status: json['status'] as String,
      mutualCount: json['mutualCount'] as int,
      sourceId: json['sourceId'] as String?,
      targetId: json['targetId'] as String?,
    );
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phoneNo': phoneNo,
      'profileUrl': profileUrl,
      'status': status,
      'mutualCount': mutualCount,
      'sourceId': sourceId,
      'targetId': targetId,
    };
  }

  @override
  String toString() {
    return 'UserCheck{id: $id, userId: $userId, name: $name, phoneNo: $phoneNo, profileUrl: $profileUrl, status: $status,'
        ' mutualCount: $mutualCount, sourceId: $sourceId, targetId: $targetId}';
  }
}