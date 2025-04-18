import 'dart:convert';

class Model {
  final String url;
  final String filename;
  final String displayName;
  final String fileSize;
  final String licenseUrl;
  final bool needsAuth;

  static final List<Model> _values = [];

  Model({
    required this.url,
    required this.filename,
    required this.displayName,
    required this.fileSize,
    required this.licenseUrl,
    required this.needsAuth,
  }) {
    _values.add(this);
  }

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      url: json['url'],
      filename: json['filename'],
      displayName: json['displayName'],
      fileSize: json['fileSize'],
      licenseUrl: json['licenseUrl'],
      needsAuth: json['needsAuth'],
    );
  }

  static List<Model> get values {
    return _values;
  }

  static void toJson({required String data}) {
    jsonDecode(data)["model"].forEach((json) => Model.fromJson(json));
  }

}
