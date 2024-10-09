// To parse this JSON data, do
//
//     final tambahAnggaranModel = tambahAnggaranModelFromJson(jsonString);

import 'dart:convert';

TambahAnggaranModel tambahAnggaranModelFromJson(String str) => TambahAnggaranModel.fromJson(json.decode(str));

String tambahAnggaranModelToJson(TambahAnggaranModel data) => json.encode(data.toJson());

class TambahAnggaranModel {
  TambahAnggaranModel({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory TambahAnggaranModel.fromJson(Map<String, dynamic> json) => TambahAnggaranModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}

Future<TambahAnggaranModel> loadTambahAnggaran(String jsonData) async {
  // String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonData);
  TambahAnggaranModel tambahAnggaran = new TambahAnggaranModel.fromJson(jsonResponse);
  return tambahAnggaran;
}