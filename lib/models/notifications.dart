class Notifications {
  final String type;
  final String sourceUserId;
  final String sourceUserName;
  final DateTime createdAt;

  Notifications({
    required this.type,
    required this.sourceUserId,
    required this.sourceUserName,
    required this.createdAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      type: json['type'] as String,
      sourceUserId: json['sourceUserId'] as String,
      sourceUserName: json['sourceUserName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sourceUserId': sourceUserId,
      'sourceUserName': sourceUserName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String getTitle() {
    switch (type) {
      case 'FRIEND_REQUEST':
        return '회원님에게 친구 요청이 도착했어요!';
      case 'MEETING_ALARM':
        return '회원님에게 모닥불이 도착했어요!';
      case 'MEETING_CANCEL_PARTICIPANT':
        return '모닥불 참여자가 취소했어요.';
      case 'MEETING_CANCEL_HOST':
        return '모닥불이 취소되었어요.';
      default:
        return '알림';
    }
  }

  String getContent() {
    switch (type) {
      case 'FRIEND_REQUEST':
        return '$sourceUserName님이 회원님과 친구가 되고 싶어해요!';
      case 'MEETING_ALARM':
        return '$sourceUserName님이 회원님을 모임에 초대하였습니다.';
      case 'MEETING_CANCEL_PARTICIPANT':
        return '$sourceUserName님이 모임 참여를 취소했습니다.';
      case 'MEETING_CANCEL_HOST':
        return '$sourceUserName님이 모임을 취소했습니다.';
      default:
        return '알림 내용을 확인해주세요.';
    }
  }

  @override
  String toString() {
    return 'Notifications(type: $type, sourceUserId: $sourceUserId, sourceUserName: $sourceUserName, createdAt: $createdAt)';
  }
}