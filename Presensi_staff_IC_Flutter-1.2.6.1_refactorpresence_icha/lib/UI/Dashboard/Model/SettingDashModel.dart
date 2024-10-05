// To parse this JSON data, do
//
//     final settingDashboard = settingDashboardFromJson(jsonString);

import 'dart:convert';

SettingDashboard settingDashboardFromJson(String str) => SettingDashboard.fromJson(json.decode(str));

String settingDashboardToJson(SettingDashboard data) => json.encode(data.toJson());

class SettingDashboard {
  SettingDashboard({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory SettingDashboard.fromJson(Map<String, dynamic> json) => SettingDashboard(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.nama,
    required this.img,
    required this.validFrom,
    required this.validUntil,
  });

  late String id;
  late String nama;
  late String img;
  late DateTime validFrom;
  late DateTime validUntil;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nama: json["nama"],
    img: json["img"],
    validFrom: DateTime.parse(json["valid_from"]),
    validUntil: DateTime.parse(json["valid_until"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "img": img,
    "valid_from": validFrom.toIso8601String(),
    "valid_until": validUntil.toIso8601String(),
  };
}

Future<SettingDashboard> loadSettingDash(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  SettingDashboard settingDash = new SettingDashboard.fromJson(jsonResponse);
  return settingDash;
}