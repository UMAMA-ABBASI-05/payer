class SystemUser {
  final int userId;
  final String userName;
  final String email;
  final String insurance_id;

  SystemUser({
    required this.userId,
    required this.userName,
    required this.email,
    required this.insurance_id,
  });

  factory SystemUser.fromJson(Map<String, dynamic> json) {
    return SystemUser(
      userId: json['user_id'],
      userName: json['user_name'],
      email: json['email'],
      insurance_id: json['insurance_id'],
    );
  }
}
