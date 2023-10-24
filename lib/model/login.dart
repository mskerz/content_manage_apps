class LoginResponse {
  final String email;
  final String jwtToken;
  final int userId;
  final int loginStatus;

  const LoginResponse({
    required this.email,
    required this.jwtToken,
    required this.userId,
    required this.loginStatus,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      email: json['email'],
      jwtToken: json['jwt_token'],
      userId: json['user_id'],
      loginStatus: json['status'],
    );
  }

  String getToken() {
    return jwtToken;
  }
}