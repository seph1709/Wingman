import 'package:flexi/model/model.dart';
import 'package:flexi/services/download_service.dart';
import 'package:flexi/view/widgets/token_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/chat_data_controller.dart';
import '../controller/llm_controller.dart';

class DownloadView extends StatelessWidget {
  const DownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xf0212529),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 70),
                child: ListView.builder(
                  itemCount: Model.values.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Model.values[index].displayName,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  Model.values[index].fileSize,
                                  style: TextStyle(color: Colors.white30),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final chatDataController =
                                  Get.find<ChatDataController>();
                              final controller = Get.find<LLMController>();
                              final isGranted =
                                  await Permission.storage.request().isGranted;
                              final token = controller.getToken();

                              if (Model.values[index].needsAuth &&
                                  token.isEmpty) {
                                chatDataController.showTokenField = true;
                                chatDataController.update();
                                return;
                              }

                              if (isGranted) {
                                DownloadService.downloadModel(
                                  url: Model.values[index].url,
                                  needsToken: Model.values[index].needsAuth,
                                  filename: Model.values[index].filename,
                                );
                              }
                            },
                            child: Icon(
                              Symbols.arrow_circle_down_rounded,
                              color: Colors.blue,
                              size: 30,
                              weight: 200,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.sizeOf(context).width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Color(0xf0212529)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Download Model",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      GetBuilder<ChatDataController>(
                        builder: (c) {
                          return GestureDetector(
                            onTap: () {
                              c.showTokenField = true;
                              c.update();
                            },
                            child: Icon(
                              Ionicons.key_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              GetBuilder<ChatDataController>(
                builder: (c) {
                  return c.showTokenField ? TokenInputWidget() : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
