import 'package:flexi/controller/chat_data_controller.dart';
import 'package:flexi/view/download_view.dart';
import 'package:flexi/view/widgets/attach_file_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../controller/llm_controller.dart';
import '../model/chat_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          surfaceContainerHighest: Color(0xff1565c0),
          onInverseSurface: Colors.black12,
          primary: Color(0xff1565c0),
        ),
        scaffoldBackgroundColor: Color(0xf0212529),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GetBuilder<ChatDataController>(
                builder: (c) {
                  return ChatModel.data.isEmpty
                      ? Center(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            "assets/images/logo.png",
                            color: Color(0xf0343a40),
                          ),
                        ),
                      )
                      : ListView.builder(
                        controller: c.scrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: ChatModel.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 60 : 0,
                              bottom:
                                  ChatModel.data.length - 1 == index ? 90 : 0,
                            ),
                            child: c.chatProducer(index),
                          );
                        },
                      );
                },
              ),
              IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                  decoration: BoxDecoration(
                    color: Color(0xf0212529),
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 2),
                    ),
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  child: Stack(
                    children: [
                      Center(
                        child: GetBuilder<LLMController>(
                          builder: (c) {
                            return GestureDetector(
                              onTap: () {
                                if (c.modelNotStartedToInstall) {
                                  c.loadModel();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // color: Colors.black12,
                                ),
                                child: IntrinsicWidth(
                                  child: Row(
                                    children: [
                                      Text(
                                        c.modelName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      !c.modelNotStartedToInstall
                                          ? LoadingAnimationWidget.threeArchedCircle(
                                            color: Colors.white,
                                            size: 20,
                                          )
                                          : Icon(
                                            Symbols.swap_horiz_rounded,
                                            size: 20,
                                            weight: 400,
                                            color: Colors.white,
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              launchUrl(
                                Uri.parse(
                                  "https://github.com/seph1709/Wingman",
                                ),
                              );
                            },
                            child: Icon(Ionicons.logo_github),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(DownloadView());
                            },
                            child: Icon(Ionicons.download_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Color(0xf0212529)),
                  child: Column(
                    children: [
                      GetBuilder<LLMController>(
                        builder: (c) {
                          return c.showDoc
                              ? AttachFileWidget(
                                fileName: c.docText!["name"],
                                fileSize: c.docText!["size"].toString(),
                              )
                              : Container();
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              controller: _textEditingController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                hintText: "Type something...",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                isDense: true,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GetBuilder<LLMController>(
                                    builder: (c) {
                                      return GestureDetector(
                                        onTap: () {
                                          if(c.modelNotStartedToInstall) {
                                            c.showTuneWidget = true;
                                            c.update();
                                          }
                                        },
                                        child: GetBuilder<LLMController>(
                                          builder: (c) {
                                            return Icon(
                                              Symbols.tune_rounded,
                                              size: 25,
                                              color:
                                                  !c.modelNotStartedToInstall
                                                      ? Color(0x18FFFFFF)
                                                      : Colors.white,
                                              weight: 500,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 15),
                                  GetBuilder<LLMController>(
                                    builder: (c) {
                                      return GestureDetector(
                                        onTap: () {
                                          final cd =
                                              Get.find<ChatDataController>();
                                          if (c.docText == null &&
                                              !(cd.continues ||
                                                  (!c.isModelSuccessfullyInstalled))) {
                                            c.pickDocFile();
                                          }
                                        },
                                        child: Icon(
                                          Symbols.attach_file_rounded,
                                          size: 25,
                                          color:
                                              !c.modelNotStartedToInstall
                                                  ? Color(0x18FFFFFF)
                                                  : Colors.white,
                                          weight: 500,
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 15),
                                  GetBuilder<LLMController>(
                                    builder: (c) {
                                      return GetBuilder<ChatDataController>(
                                        builder: (cd) {
                                          return Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  cd.continues ||
                                                          (!c.isModelSuccessfullyInstalled)
                                                      ? Colors.transparent
                                                      : Colors.blue[800],
                                            ),
                                            child: GetBuilder<LLMController>(
                                              builder: (c) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    if (!c
                                                        .modelNotStartedToInstall) {
                                                      return;
                                                    }
                                                    if (_textEditingController
                                                            .text
                                                            .isNotEmpty &&
                                                        !cd.continues) {
                                                      final userPrompt =
                                                          _textEditingController
                                                              .text;
                                                      cd.addData(
                                                        "user",
                                                        userPrompt,
                                                      );
                                                      _textEditingController
                                                          .clear();
                                                      await c.createSession();
                                                      c.talkToModel(userPrompt);
                                                    } else if (cd.continues) {
                                                      c.stopGenerating = true;
                                                    }
                                                  },
                                                  child: GetBuilder<
                                                    LLMController
                                                  >(
                                                    builder: (c) {
                                                      return GetBuilder<
                                                        ChatDataController
                                                      >(
                                                        builder: (cd) {
                                                          return Icon(
                                                            cd.continues
                                                                ? Symbols
                                                                    .stop_circle_rounded
                                                                : Symbols
                                                                    .arrow_upward_rounded,
                                                            size: 27,
                                                            color:
                                                                cd.continues ||
                                                                        (!c.isModelSuccessfullyInstalled)
                                                                    ? Color(
                                                                      0x18FFFFFF,
                                                                    )
                                                                    : Colors
                                                                        .white,
                                                            weight: 600,
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GetBuilder<LLMController>(
                builder: (c) {
                  return (c.showTuneWidget)
                      ? Center(
                        child: IntrinsicHeight(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xf0212529),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Parameters",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "RandomSeed: ${c.seedValue.truncateToDouble()}",
                                  ),
                                  Slider(
                                    activeColor: Colors.blue[800],
                                    inactiveColor: Colors.grey,
                                    value: c.seedValue,
                                    min: 1,
                                    max: 10,
                                    onChanged: (v) {
                                      c.seedValue = v;
                                      c.update();
                                    },
                                  ),
                                  Text(
                                    "topK: ${c.topKValue.truncateToDouble()}",
                                  ),
                                  Slider(
                                    activeColor: Colors.blue[800],
                                    inactiveColor: Colors.grey,
                                    value: c.topKValue,
                                    min: 1,
                                    max: 10,
                                    onChanged: (v) {
                                      c.topKValue = v;
                                      c.update();
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      c.showTuneWidget = false;
                                      c.update();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "DONE",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
