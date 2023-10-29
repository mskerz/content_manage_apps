class RequestResponse {
  final String message;
  final int status;
   

  const RequestResponse({
   required this.message,
   required this.status,

  });

  factory RequestResponse.fromJson(Map<String, dynamic> json,int status) {
    return RequestResponse(
      message: json['message'], 
      status: status,
     
    );
  }

   
}