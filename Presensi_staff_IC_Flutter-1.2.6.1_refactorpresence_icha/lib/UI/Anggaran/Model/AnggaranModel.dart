// To parse this JSON data, do
//
//     final anggaran = anggaranFromJson(jsonString);

import 'dart:convert';

Anggaran anggaranFromJson(String str) => Anggaran.fromJson(json.decode(str));

String anggaranToJson(Anggaran data) => json.encode(data.toJson());

class Anggaran {
  Anggaran({
    required this.status,
    required this.message,
    required this.ringkasan,
    required this.data,
    required this.rows,
  });

  bool status;
  String message;
  List<Ringkasan> ringkasan;
  List<IsiData> data;
  int rows;

  factory Anggaran.fromJson(Map<String, dynamic> json) => Anggaran(
        status: json["status"] ?? false,
        message: json["message"],
        ringkasan: List<Ringkasan>.from(
            json["ringkasan"].map((x) => Ringkasan.fromJson(x))),
        data: List<IsiData>.from(json["data"].map((x) => IsiData.fromJson(x))),
        rows: json["rows"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "ringkasan": List<dynamic>.from(ringkasan.map((x) => x.toJson())),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "rows": rows,
      };
}

class IsiData {
  IsiData({
    required this.id,
    required this.idStaf,
    required this.judul,
    required this.nominal,
    required this.status,
    required this.waktuRequest,
    required this.keterangan,
    required this.feedback,
    required this.createdAt,
    required this.statusBy,
    required this.statusAt,
    required this.updateBy,
    required this.updateAt,
  });

  String id;
  String idStaf;
  String judul;
  String nominal;
  String status;
  DateTime waktuRequest;
  dynamic keterangan;
  dynamic feedback;
  DateTime createdAt;
  String statusBy;
  DateTime statusAt;
  String updateBy;
  DateTime updateAt;

  factory IsiData.fromJson(Map<String, dynamic> json) => IsiData(
        id: json["id"],
        idStaf: json["id_staf"],
        judul: json["judul"],
        nominal: json["nominal"],
        status: json["status"],
        waktuRequest: DateTime.parse(json["waktu_request"]),
        keterangan: json["Keterangan"],
        feedback: json["feedback"],
        createdAt: DateTime.parse(json["created_at"]),
        statusBy: json["status_by"],
        statusAt: DateTime.parse(json["status_at"]),
        updateBy: json["update_by"],
        updateAt: DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_staf": idStaf,
        "judul": judul,
        "nominal": nominal,
        "status": status,
        "waktu_request": waktuRequest.toIso8601String(),
        "Keterangan": keterangan,
        "feedback": feedback,
        "created_at": createdAt.toIso8601String(),
        "status_by": statusBy,
        "status_at": statusAt.toIso8601String(),
        "update_by": updateBy,
        "update_at": updateAt.toIso8601String(),
      };
}

class Ringkasan {
  Ringkasan({
    required this.diajukan,
    required this.diterima,
    required this.dibelanjakan,
    required this.sisa,
  });

  String diajukan;
  String diterima;
  String dibelanjakan;
  String sisa;

  factory Ringkasan.fromJson(Map<String, dynamic> json) => Ringkasan(
        diajukan: json["diajukan"] ?? "",
        diterima: json["diterima"] ?? "",
        dibelanjakan: json["dibelanjakan"] ?? "",
        sisa: json["sisa"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "diajukan": diajukan,
        "diterima": diterima,
        "dibelanjakan": dibelanjakan,
        "sisa": sisa,
      };
}

Future<Anggaran> loadAnggaran(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  Anggaran anggaran = new Anggaran.fromJson(jsonResponse);
  return anggaran;
}
