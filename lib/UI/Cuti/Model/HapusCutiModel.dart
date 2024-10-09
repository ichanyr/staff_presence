// To parse this JSON data, do
//
//     final hapusCutiModel = hapusCutiModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HapusCutiModel hapusCutiModelFromJson(String str) => HapusCutiModel.fromJson(json.decode(str));

String hapusCutiModelToJson(HapusCutiModel data) => json.encode(data.toJson());

class HapusCutiModel {
  HapusCutiModel({
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  factory HapusCutiModel.fromJson(Map<String, dynamic> json) => HapusCutiModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}

Future<HapusCutiModel> loadDelCuti(String jsonData) async {
  String jsonDelCuti = jsonData;
  final jsonResponse = json.decode(jsonDelCuti);
  HapusCutiModel delCuti = new HapusCutiModel.fromJson(jsonResponse);
  return delCuti;
}