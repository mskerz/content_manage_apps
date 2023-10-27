class RegisterResponse {
  final String message;
  final int status;
   

  const RegisterResponse({
   required this.message,
   required this.status,

  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json,int status) {
    return RegisterResponse(
      message: json['message'], 
      status: status,
     
    );
  }

   
}