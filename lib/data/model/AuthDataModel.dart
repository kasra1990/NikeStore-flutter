class AuthDataModel {
  final String? userId;
  final String? email;
  final String? message;


  AuthDataModel({required this.userId,required this.email,required this.message});

  AuthDataModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        email = json['email'],
        message = json['message'];
}
