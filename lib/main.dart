// ignore_for_file: unused_import

import 'package:flexi/services/notification_service.dart';
import 'package:flexi/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/llm_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xf0212529),
      systemNavigationBarColor: Color(0xf0212529),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  Get.put(LLMController());
  runApp(HomeView());
}
