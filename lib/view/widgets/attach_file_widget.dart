import 'package:flexi/controller/llm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class AttachFileWidget extends StatefulWidget {
  final String fileName;
  final String fileSize;
  const AttachFileWidget({super.key, required this.fileName, required this.fileSize});

  @override
  State<AttachFileWidget> createState() => _AttachFileWidgetState();
}

class _AttachFileWidgetState extends State<AttachFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Extracts only text from files. If the text is greater than 1024 tokens, it will be truncated.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xf0212529),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: IntrinsicWidth(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Icon(Symbols.description_rounded, size: 30),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                    width: 70,
                                  ),
                                  child: Text(
                                    widget.fileName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Text(widget.fileSize, style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: GetBuilder<LLMController>(
                        builder: (c) {
                          return GestureDetector(
                            onTap: (){
                              c.docText = null;
                              c.showDoc =false;
                              c.update();
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Symbols.close_rounded,
                                color: Colors.blue[800],
                                size: 15,
                                weight: 800,
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
