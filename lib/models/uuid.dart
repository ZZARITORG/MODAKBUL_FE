class Uuid {
  final String targetId;

  Uuid({required this.targetId});

  // Dart 객체를 JSON 데이터로 변환
  Map<String, String> toJson() {
    return {
      'target_id': targetId,
    };
  }

  @override
  String toString() {
    return 'Uuid(targetId: $targetId)';
  }
}