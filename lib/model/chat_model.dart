import 'dart:convert';

class ChatModel {

  static final List _data = [];

  ChatModel({required String type, required String chat}) {
    _data.add({"type": type, "chat": chat});
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(type: json["type"], chat: json["chat"]);
  }

  static List get data {
    return _data;
  }

  static void fromString({required String data}) {
    jsonDecode(data).forEach((json) => ChatModel.fromJson(json));
  }

  static String toJson() {
    return jsonEncode(_data);
  }
}
