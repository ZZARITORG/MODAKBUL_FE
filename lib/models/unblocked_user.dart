class UnblockedUser {
  final String targetId;

  UnblockedUser({required this.targetId});

  Map<String, dynamic> toJson() {
    return {
      'target_id': targetId,
    };
  }
}
