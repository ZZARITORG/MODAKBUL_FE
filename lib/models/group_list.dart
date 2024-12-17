class Group {
  final String id;
  final String name;
  final List<Member> members;
  final int count;
  final String updatedAt; // updatedAt 추가

  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.count,
    required this.updatedAt, // 생성자에 추가
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    print('Group id: ${json['members']}');
    return Group(
      id: json['id'],
      name: json['name'],
      members: (json['members'] as List)
          .map((member) => Member.fromJson(member))
          .toList(),
      count: json['count'],
      updatedAt: json['updatedAt'], // JSON에서 updatedAt 읽기
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members.map((member) => member.toJson()).toList(),
      'count': count,
      'updatedAt': updatedAt, // JSON으로 내보내기
    };
  }
}

class Member {
  final String id;
  final User user;

  Member({
    required this.id,
    required this.user,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String userId;
  final String name;
  final String profileUrl;

  User({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      profileUrl: json['profileUrl'],
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