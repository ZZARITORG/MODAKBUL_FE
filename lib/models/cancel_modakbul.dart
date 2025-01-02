class CancelModakbul {
  final String id;

  CancelModakbul({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}