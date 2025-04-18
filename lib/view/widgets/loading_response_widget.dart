import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingResponseWidget extends StatelessWidget {
  const LoadingResponseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 25),
      child: Container(
        alignment: Alignment.topLeft,
        child: LoadingAnimationWidget.waveDots(
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
