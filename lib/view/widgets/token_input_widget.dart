import 'package:flexi/controller/llm_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/chat_data_controller.dart';

class TokenInputWidget extends StatelessWidget {
  TokenInputWidget({super.key});
  final TextEditingController _textEditingController = TextEditingController();
  final chatDataController = Get.find<ChatDataController>();
  final controller = Get.find<LLMController>();

  @override
  Widget build(BuildContext context) {
    _textEditingController.value = TextEditingValue(
      text: controller.getToken(),
    );
    return GetBuilder<ChatDataController>(
      builder: (_) {
        return Center(
          child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xf0343a40),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "SET YOUR TOKEN",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "Some models require a Hugging Face token to download.",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        TextSpan(
                          text: " more info.",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 13,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = (){
                            launchUrl(
                              Uri.parse(
                                "https://huggingface.co/docs/hub/en/security-tokens",
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "paste your token here",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      controller: _textEditingController,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          chatDataController.showTokenField = false;
                          chatDataController.update();
                        },
                        child: Text(
                          "cancel",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_textEditingController.text.isNotEmpty) {
                            chatDataController.token =
                                _textEditingController.text;
                            controller.saveToken();
                            chatDataController.showTokenField = false;
                            chatDataController.update();
                          }
                        },
                        child: Text(
                          "confirm",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
