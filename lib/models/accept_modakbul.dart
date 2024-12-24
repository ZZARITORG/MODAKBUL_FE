class AcceptModakbul {
  final String meetingId;

  AcceptModakbul({
    required this.meetingId,
  });

  Map<String, dynamic> toJson() {
    return {
      'meetingId': meetingId,
    };
  }
}