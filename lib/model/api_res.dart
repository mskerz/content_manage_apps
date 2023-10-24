class ApiResponse {
  final String textFromApi;

  const ApiResponse({
    required this.textFromApi,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      textFromApi: json['message'],
    );
  }
}