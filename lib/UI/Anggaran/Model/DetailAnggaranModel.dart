// To parse this JSON data, do
//
//     final detailAnggaran = detailAnggaranFromJson(jsonString);

import 'dart:convert';

DetailAnggaran detailAnggaranFromJson(String str) => DetailAnggaran.fromJson(json.decode(str));

String detailAnggaranToJson(DetailAnggaran data) => json.encode(data.toJson());

class DetailAnggaran {
  DetailAnggaran({
    required this.status,
    required this.message,
    required this.data,
    required this.rows,
  });

  bool status;
  String message;
  List<Datum> data;
  int rows;

  factory DetailAnggaran.fromJson(Map<String, dynamic> json) => DetailAnggaran(
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
    required this.idStaf,
    required this.judul,
    required this.nominal,
    required this.status,
    required this.waktuRequest,
    required this.keterangan,
    required this.feedback,
    required this.deadline,
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
  DateTime deadline;
  DateTime createdAt;
  String statusBy;
  DateTime statusAt;
  String updateBy;
  DateTime updateAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idStaf: json["id_staf"],
    judul: json["judul"],
    nominal: json["nominal"],
    status: json["status"],
    waktuRequest: DateTime.parse(json["waktu_request"]),
    keterangan: json["Keterangan"],
    feedback: json["feedback"],
    deadline: DateTime.parse(json["deadline"]),
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
    "deadline": deadline,
    "created_at": createdAt.toIso8601String(),
    "status_by": statusBy,
    "status_at": statusAt.toIso8601String(),
    "update_by": updateBy,
    "update_at": updateAt.toIso8601String(),
  };
}

Future<DetailAnggaran> loadDetailAnggaran(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  DetailAnggaran detailAnggaran = new DetailAnggaran.fromJson(jsonResponse);
  return detailAnggaran;
}