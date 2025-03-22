class LoginResponse {
  final String userId;
  final String name;
  final String token;

  LoginResponse({
    required this.userId, 
    required this.name, 
    required this.token
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      name: json['name'],
      token: json['token'],
    );
  }
}