class UserModel {
  final String token;
  final String userId;
  final String name;
  final String email;

  UserModel({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
