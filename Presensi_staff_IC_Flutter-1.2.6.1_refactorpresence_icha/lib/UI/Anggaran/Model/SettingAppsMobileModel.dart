// To parse this JSON data, do
//
//     final settingAppsMobile = settingAppsMobileFromJson(jsonString);

import 'dart:convert';

SettingAppsMobile settingAppsMobileFromJson(String str) =>
    SettingAppsMobile.fromJson(json.decode(str));

String settingAppsMobileToJson(SettingAppsMobile data) =>
    json.encode(data.toJson());

class SettingAppsMobile {
  SettingAppsMobile({
    required this.status,
    required this.message,
    required this.data,
    required this.rows,
  });

  bool status;
  String message;
  List<Datum> data;
  int rows;

  factory SettingAppsMobile.fromJson(Map<String, dynamic> json) =>
      SettingAppsMobile(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        rows: json["rows"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "rows": rows,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.deadlineAnggaran,
  });

  String id;
  String deadlineAnggaran;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        deadlineAnggaran: json["deadline_anggaran"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deadline_anggaran": deadlineAnggaran,
      };
}

Future<SettingAppsMobile> loadSetting(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  SettingAppsMobile settingApps = new SettingAppsMobile.fromJson(jsonResponse);
  return settingApps;
}
