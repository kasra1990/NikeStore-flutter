class MessageModel {
  final String message;

  MessageModel.fromJson(Map<String, dynamic> json) : message = json['message'];
}
