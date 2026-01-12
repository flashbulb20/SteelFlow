/// 사용자 정보를 표현하는 데이터 모델
class UserModel {
  final int id;
  final String username;
  final String? email;
  final String? phone;
  final String? role;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.phone,
    this.role,
  });

  /// JSON -> UserModel 변환
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  /// UserModel -> JSON 변환
  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "role": role,
  };
}
