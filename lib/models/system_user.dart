class SystemUser {
  final int userId;
  final String userName;
  final String email;

  SystemUser({
    required this.userId,
    required this.userName,
    required this.email,
  });

  factory SystemUser.fromJson(Map<String, dynamic> json) {
    return SystemUser(
      userId: json['user_id'],
      userName: json['user_name'],
      email: json['email'],
    );
  }
}
