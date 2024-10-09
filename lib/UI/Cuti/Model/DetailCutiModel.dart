// To parse this JSON data, do
//
//     final detailCutiModel = detailCutiModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DetailCutiModel detailCutiModelFromJson(String str) => DetailCutiModel.fromJson(json.decode(str));

String detailCutiModelToJson(DetailCutiModel data) => json.encode(data.toJson());

class DetailCutiModel {
  DetailCutiModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<Datum> data;

  factory DetailCutiModel.fromJson(Map<String, dynamic> json) => DetailCutiModel(
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
    required this.izin,
    required this.ket,
    required this.img,
    required this.hari,
    required this.status,
    required this.id,
    required this.max,
    required this.min,
  });

  final String izin;
  final String ket;
  final String img;
  final String hari;
  final String status;
  final String id;
  final DateTime max;
  final DateTime min;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    izin: json["izin"],
    ket: json["ket"],
    img: json["img"],
    hari: json["hari"],
    status: json["status"],
    id: json["id"],
    max: DateTime.parse(json["max"]),
    min: DateTime.parse(json["min"]),
  );

  Map<String, dynamic> toJson() => {
    "izin": izin,
    "ket": ket,
    "img": img,
    "hari": hari,
    "status": status,
    "id": id,
    "max": max.toIso8601String(),
    "min": min.toIso8601String(),
  };
}

Future<DetailCutiModel> loadDetailCuti(String jsonData) async {
  String jsonGetDetailCuti = jsonData;
  final jsonResponse = json.decode(jsonGetDetailCuti);
  DetailCutiModel getDetailCuti = new DetailCutiModel.fromJson(jsonResponse);
  return getDetailCuti;
}