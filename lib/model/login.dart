class LoginResponse {
  final String jwtToken;
  final int userId;
  final int loginStatus;
  final int statusCode;

  const LoginResponse(
      {required this.jwtToken,
      required this.userId,
      required this.loginStatus,
      required this.statusCode});

  factory LoginResponse.fromJson(Map<String, dynamic> json, int status) {
    return LoginResponse(
        jwtToken: json['jwt_token'] != null ? json['jwt_token'] : '',
        userId: json['user_id'] != null ? json['user_id'] : 0,
        loginStatus: json['status'],
        statusCode: status);
  }

  String getToken() {
    return jwtToken;
  }
}
