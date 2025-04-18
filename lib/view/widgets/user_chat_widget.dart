import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';


class UserChatWidget extends StatelessWidget {
  final String prompt;

  const UserChatWidget({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 14),
          margin: EdgeInsets.only(right: 15, top: 5, bottom: 5, left: 100),
          decoration: BoxDecoration(
            color: Color(0xf0495057),
            borderRadius: BorderRadius.circular(15),
          ),
          child: GptMarkdown(prompt,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
