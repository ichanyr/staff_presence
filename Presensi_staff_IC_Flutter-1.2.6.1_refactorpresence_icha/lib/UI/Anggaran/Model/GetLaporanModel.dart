// To parse this JSON data, do
//
//     final getLaporan = getLaporanFromJson(jsonString);

import 'dart:convert';

LaporanAnggaran getLaporanFromJson(String str) => LaporanAnggaran.fromJson(json.decode(str));

String getLaporanToJson(LaporanAnggaran data) => json.encode(data.toJson());

class LaporanAnggaran {
  LaporanAnggaran({
    required this.status,
    required this.message,
    required this.data,
    required this.uang,
    required this.jumlah,
  });

  bool status;
  String message;
  List<Datum> data;
  List<Uang> uang;
  int jumlah;

  factory LaporanAnggaran.fromJson(Map<String, dynamic> json) => LaporanAnggaran(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    uang: List<Uang>.from(json["uang"].map((x) => Uang.fromJson(x))),
    jumlah: json["jumlah"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "uang": List<dynamic>.from(uang.map((x) => x.toJson())),
    "jumlah": jumlah,
  };
}

class Datum {
  Datum({
    required this.id,
    required this.idReq,
    required this.item,
    required this.nominal,
    required this.waktu,
    required this.catatan,
    required this.bukti,
    required this.status,
    required this.updatedBy,
    required this.updateAt,
  });

  String id;
  String idReq;
  String item;
  String nominal;
  DateTime waktu;
  String catatan;
  dynamic bukti;
  String status;
  String updatedBy;
  DateTime updateAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idReq: json["id_req"],
    item: json["item"],
    nominal: json["nominal"],
    waktu: DateTime.parse(json["waktu"]),
    catatan: json["catatan"] == null ? null : json["catatan"],
    bukti: json["bukti"],
    status: json["status"],
    updatedBy: json["updated_by"],
    updateAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_req": idReq,
    "item": item,
    "nominal": nominal,
    "waktu": waktu.toIso8601String(),
    "catatan": catatan,
    "bukti": bukti,
    "status": status,
    "updated_by": updatedBy,
    "update_at": updateAt.toIso8601String(),
  };
}

class Uang {
  Uang({
    required this.anggaran,
    required this.dibelanjakan,
  });

  String anggaran;
  String dibelanjakan;

  factory Uang.fromJson(Map<String, dynamic> json) => Uang(
    anggaran: json["anggaran"],
    dibelanjakan: json["dibelanjakan"],
  );

  Map<String, dynamic> toJson() => {
    "anggaran": anggaran,
    "dibelanjakan": dibelanjakan,
  };
}

Future<LaporanAnggaran> loadGetAnggaran(String jsonData) async {
  String jsonLaporanAnggaran = jsonData;
  final jsonResponse = json.decode(jsonLaporanAnggaran);
  LaporanAnggaran getLaporan = new LaporanAnggaran.fromJson(jsonResponse);
  return getLaporan;
}