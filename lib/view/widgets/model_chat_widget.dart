import 'package:flexi/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../controller/chat_data_controller.dart';

class ModelChatWidget extends StatefulWidget {
  final String response;
  final bool islastChat;

  const ModelChatWidget({
    super.key,
    required this.response,
    required this.islastChat,
  });

  @override
  State<ModelChatWidget> createState() => _ModelChatWidgetState();
}

class _ModelChatWidgetState extends State<ModelChatWidget>
    with TickerProviderStateMixin {
  var isCopied = false;
  final ChatDataController chatDataController = Get.find<ChatDataController>();
  // final animationController = AnimationController(vsync: );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: MediaQuery.sizeOf(context).width,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors.black12,
                  ),
                  child: SelectableRegion(
                    selectionControls: materialTextSelectionControls,
                    child: GptMarkdown(
                      widget.response,
                      style: TextStyle(color: Colors.white, fontSize: 13.5),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.response));
                  setState(() {
                    isCopied = true;
                  });
                },
                child: GetBuilder<ChatDataController>(
                  builder: (c) {
                    return c.continues && widget.islastChat
                        ? Container()
                        : Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blue, width: 0.2),
                            // borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            children: [
                              Icon(
                                Symbols.content_copy_rounded,
                                color: Colors.grey,
                                size: 17,
                              ),
                              SizedBox(width: 5),
                              Text(
                                isCopied ? "copied" : "copy content",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                  },
                ),
              ),
              GetBuilder<ChatDataController>(
                builder: (c) {
                  return (!(c.continues) &&
                          widget.islastChat &&
                          ChatModel.data.length >= 4)
                      ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              c.clearChat();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Icon(
                                      Symbols.clear_all_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      weight: 300,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "clear chat",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      : Container();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
