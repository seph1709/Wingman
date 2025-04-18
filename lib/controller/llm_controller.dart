// ignore_for_file: unused_import, unused_field

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexi/model/chat_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model.dart';
import '../view/home_view.dart';
import 'chat_data_controller.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:path/path.dart';

class LLMController extends GetxController {
  File? _file;

  late FlutterGemmaPlugin _gemma;

  late ModelFileManager _modelManager;

  InferenceModel? _inferenceModel;

  late InferenceModelSession _session;

  late ChatDataController _chatDataController;

  late SharedPreferencesAsyncAndroidOptions _options;

  late SharedPreferences _prefs;

  late bool? _isModelInstalled;

  var modelNotStartedToInstall = true;

  var isModelSuccessfullyInstalled = false;

  late File _doc;

  var stopGenerating = false;

  var showTuneWidget = false;

  var seedValue = 1.0;

  var temperatureValue = 1.0;

  var topKValue = 2.0;

  var modelName = "Load Model";

  var showDoc = false;

  Map? docText;

  @override
  void onInit() async {
    super.onInit();
    _gemma = FlutterGemmaPlugin.instance;
    _modelManager = _gemma.modelManager;
    _chatDataController = Get.put(ChatDataController());
    _options = SharedPreferencesAsyncAndroidOptions();
    _prefs = await SharedPreferences.getInstance();

    _loadData();
    if (_file != null) {
      modelNotStartedToInstall = false;
      if (kDebugMode) {
        print("-----model file not null-----");
      }

      processModel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _inferenceModel?.close();
  }

  Future<void> _deleteOtherModel() async {
    if (_file != null) {
      final dir = Directory(_file!.parent.path).parent.parent;
      final listFiles = await dir.list().toList();
      for (var dirEntity in listFiles) {
        final currentModelName = basename(_file!.path);
        if (!(dirEntity.path.contains(currentModelName))) {
          if (kDebugMode) {
            print("-----old model will be deleted: ${dirEntity.path}-----");
          }
          final dirToDelete = Directory(dirEntity.path);
          dirToDelete.deleteSync(recursive: true);
          if (kDebugMode) {
            print("-----old model successfully deleted-----");
          }
        } else {
          if (kDebugMode) {
            print("-----exempted: ${dirEntity.path}-----");
          }
        }
      }
    }
  }

  String getToken() {
    final tempToken = _prefs.getString('token');
    return tempToken ?? "";
  }

  void _loadData() {
    final tempPath = _prefs.getString('getModelPath');
    final chatData = _prefs.getString('chatData');
    if (chatData != null) {
      ChatModel.fromString(data: chatData);
    }
    if (tempPath != null) {
      _file = File(tempPath);
    }
  }

  Future<void> saveToken() async {
    await _prefs.setString('token', _chatDataController.token);
  }

  Future<void> loadModel() async {
    final isSuccessful = await pickModel();
    if (isSuccessful) {
      await processModel();
    }
  }

  void _setModelNotInstalled() {
    modelNotStartedToInstall = false;
    isModelSuccessfullyInstalled = false;
    update();
  }

  Future<bool> pickModel() async {
    _setModelNotInstalled();
    // pick a model file
    await Permission.storage.request().isGranted;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var tempPath = result?.files.single.path;

    if (tempPath == null ||
        !(tempPath.contains(".bin") || tempPath.contains(".task"))) {
      if (kDebugMode) {
        print("-----no file selected-----");
      }
      modelNotStartedToInstall = true;
      if (_file != null) {
        isModelSuccessfullyInstalled = true;
      }
      update();
      return false;
    } else {
      _file = File(tempPath);
      if (kDebugMode) {
        print("-----selected file: ${_file?.path}-----");
      }
      return true;
    }
  }

  Future<void> pickDocFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    var tempPath = result?.files.single.path.toString();

    if (tempPath == null) return;

    _doc = File(tempPath);
    late String text;

    final file = File(_doc.path);

    final bytes = await file.readAsBytes();

    if (tempPath.contains(".doc")) {
      text = docxToText(bytes, handleNumbering: true);
    } else if (tempPath.contains(".pdf")) {
      text = await ReadPdfText.getPDFtext(file.path);
    } else {
      return;
    }

    var tokNum = text.split(" ").length;

    if (tokNum >= 1024) {
      text = text.substring(0, 512);
    }

    docText = {
      "name": basename(file.path),
      "size": await getFileSize(file.path, 2),
      "content": text,
    };

    showDoc = true;
    update();
  }

  Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Future<void> processModel() async {
    if (kDebugMode) {
      print("-----process started-----");
    }
    try {
      final isSuccessful = await setModal();
      if (isSuccessful) {
        await createModel();
        update();
      } else {
        if (kDebugMode) {
          print("-----Not successful installed ${_file?.path}-----");
        }
      }
    } on Exception {
      resetFile();
    }
  }

  Future<void> resetFile() async {
    if (kDebugMode) {
      print("-----invalid file-----");
    }
    modelNotStartedToInstall = true;
    _deleteOtherModel();
    update();
  }

  Future<void> saveData() async {
    await _prefs.setString('chatData', ChatModel.toJson());
    if (_file != null) {
      if (_file!.path.contains(".bin") || _file!.path.contains(".task")) {
        await _prefs.setString('getModelPath', _file!.path);
        if (kDebugMode) {
          print("-----saved model path-----");
        }
      } else {
        if (kDebugMode) {
          print("-----cannot save: ${_file?.path}-----");
        }
      }
    }
  }

  Future<bool> setModal() async {
    await _modelManager.deleteModel();
    await _modelManager.setModelPath(_file!.path);
    return _modelManager.isModelInstalled.then((isInstalled) {
      return isInstalled;
    });
  }

  Future<void> createModel([int? maxToken]) async {
    try {
      if (_inferenceModel != null) {
        await _inferenceModel!.close();
      }
      _inferenceModel = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt,
        preferredBackend:
            _file!.path.contains("gpu")
                ? PreferredBackend.gpu
                : PreferredBackend.cpu,
        maxTokens: maxToken ?? 1024,
      );
      await saveData();
      modelName = basename(_file!.path);
      setModelInstalled();
      if (kDebugMode) {
        print("-----successfully installed model-----");
        _deleteOtherModel();
      }
    } on PlatformException {
      resetFile();
    }
  }

  void setModelInstalled() {
    modelNotStartedToInstall = true;
    isModelSuccessfullyInstalled = true;
    update();
  }

  Future<void> createSession() async {
    _chatDataController.continues = true;
    if (_inferenceModel == null) {
      await createModel();
    }
    _session = await _inferenceModel!.createSession(
      temperature: temperatureValue,
      randomSeed: seedValue.toInt(),
      topK: topKValue.toInt(),
    );
  }

  Future<void> talkToModel(String prompt) async {
    showDoc = false;
    update();
    await _session.addQueryChunk(
      Message(
        text:
            docText != null
                ? "''''${docText!["content"]}''''\n$prompt"
                : prompt,
      ),
    );
    _session.getResponseAsync().listen(
      (String token) async {
        _chatDataController.addData("model", token);
        docText = null;

        update();
      },
      onDone: () async {
        _chatDataController.continues = false;
        update();
        await _session.close();
        await saveData();
      },
      onError: (error) async {
        ChatModel(type: "model", chat: error.toString());
      },
      cancelOnError: true,
    );
  }
}
