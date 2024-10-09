// To parse this JSON data, do
//
//     final tambahAnggaranModel = tambahAnggaranModelFromJson(jsonString);

import 'dart:convert';

KurangAnggaranModel tambahAnggaranModelFromJson(String str) => KurangAnggaranModel.fromJson(json.decode(str));

String kurangAnggaranModelToJson(KurangAnggaranModel data) => json.encode(data.toJson());

class KurangAnggaranModel {
  KurangAnggaranModel({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory KurangAnggaranModel.fromJson(Map<String, dynamic> json) => KurangAnggaranModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}

Future<KurangAnggaranModel> loadKurangAnggaran(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  KurangAnggaranModel kurangAnggaran = new KurangAnggaranModel.fromJson(jsonResponse);
  return kurangAnggaran;
}