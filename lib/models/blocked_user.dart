class BlockedUser {
  final String userId;
  final String name;
  final String profileUrl;
  final String id;

  BlockedUser({
    required this.userId,
    required this.name,
    required this.profileUrl,
    required this.id,
  });

  // Factory constructor to create a UserProfile instance from JSON
  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      id: json['id'] as String,
    );
  }
}

// Utility function to parse a list of UserProfile from JSON
List<BlockedUser> blockedUserListFromJson(List jsonList) {
  return jsonList.map((json) => BlockedUser.fromJson(json)).toList();
}
