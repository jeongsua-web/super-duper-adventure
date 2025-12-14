class User {
  final String id;
  final String username;  // 아이디
  final String name;      // 이름 (기존)
  final String realName;  // 실명
  final String email;
  final String? gender;   // 성별 (nullable)
  final String? job;      // 직업 (nullable)

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.realName,
    required this.email,
    this.gender,
    this.job,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      name: json['name'] as String,
      realName: json['realName'] as String? ?? json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String?,
      job: json['job'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'name': name,
    'realName': realName,
    'email': email,
    if (gender != null) 'gender': gender,
    if (job != null) 'job': job,
  };
}