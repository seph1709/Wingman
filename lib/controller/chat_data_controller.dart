import 'dart:async';
import 'package:flexi/model/chat_model.dart';
import 'package:flexi/view/widgets/loading_response_widget.dart';
import 'package:flexi/view/widgets/model_chat_widget.dart';
import 'package:flexi/view/widgets/user_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';
import 'llm_controller.dart';

class ChatDataController extends GetxController {
  var continues = false;

  var showTokenField = false;

  var token = "";

  var goToHome = false;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    super.onInit();
    final response = await http.get(
      Uri.parse(
        "https://raw.githubusercontent.com/seph1709/Wingman/refs/heads/main/model.json",
      ),
    );
    if (response.statusCode == 200) {
      Model.toJson(data: response.body);
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    scrollDown();
  }
  void addData(String type, String chat) {
    if (ChatModel.data.isNotEmpty &&
        ChatModel.data.last["type"] == "model" &&
        type == "model") {
      var lastMessage = ChatModel.data.last["chat"];
      lastMessage += chat;
      ChatModel.data.last = {"type": type, "chat": lastMessage};
      scrollDown();
    } else {
      ChatModel(type: type, chat: chat);
      scrollDown();
    }
  }

  void scrollDown() {
    update();
    Timer(
      Duration(milliseconds: 100),
      () => scrollController.jumpTo(scrollController.position.maxScrollExtent),
    );
  }

  Future<void> clearChat() async{
    ChatModel.data.clear();
    update();
   await Get.find<LLMController>().saveData();
  }

  Widget chatProducer(int index) {
    late final Widget chatWidget;
    if (ChatModel.data[index]["type"] == "user" &&
        ChatModel.data.length - 1 == index) {
      chatWidget = Column(
        children: [
          UserChatWidget(prompt: ChatModel.data[index]["chat"]),
          LoadingResponseWidget(),
        ],
      );
    } else if (ChatModel.data[index]["type"] == "user") {
      chatWidget = UserChatWidget(prompt: ChatModel.data[index]["chat"]);
    } else {
      chatWidget = ModelChatWidget(
        response: ChatModel.data[index]["chat"],
        islastChat: ChatModel.data.length - 1 == index,
      );
    }
    return chatWidget;
  }
}
