// To parse this JSON data, do
//
//     final insertCutiModel = insertCutiModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

InsertCutiModel insertCutiModelFromJson(String str) => InsertCutiModel.fromJson(json.decode(str));

String insertCutiModelToJson(InsertCutiModel data) => json.encode(data.toJson());

class InsertCutiModel {
  InsertCutiModel({
    required this.status,
    required this.message,
    required this.jatahCuti,
    required this.jumlahCuti,
  });

  final bool status;
  final String message;
  final List<JatahCuti> jatahCuti;
  final JumlahCuti jumlahCuti;

  factory InsertCutiModel.fromJson(Map<String, dynamic> json) => InsertCutiModel(
    status: json["status"],
    message: json["message"],
    jatahCuti: List<JatahCuti>.from(json["jatah_cuti"].map((x) => JatahCuti.fromJson(x))),
    jumlahCuti: JumlahCuti.fromJson(json["jumlah_cuti"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "jatah_cuti": List<dynamic>.from(jatahCuti.map((x) => x.toJson())),
    "jumlah_cuti": jumlahCuti.toJson(),
  };
}

class JatahCuti {
  JatahCuti({
    required this.idStaff,
    required this.name,
    required this.cabang,
    required this.isMagang,
    required this.isStaff,
    required this.isTentor,
    required this.cuti,
    required this.cutiMagang,
  });

  final String idStaff;
  final String name;
  final String cabang;
  final String isMagang;
  final String isStaff;
  final String isTentor;
  final String cuti;
  final String cutiMagang;

  factory JatahCuti.fromJson(Map<String, dynamic> json) => JatahCuti(
    idStaff: json["id_staff"],
    name: json["name"],
    cabang: json["cabang"],
    isMagang: json["is_magang"],
    isStaff: json["is_staff"],
    isTentor: json["is_tentor"],
    cuti: json["cuti"],
    cutiMagang: json["cuti_magang"],
  );

  Map<String, dynamic> toJson() => {
    "id_staff": idStaff,
    "name": name,
    "cabang": cabang,
    "is_magang": isMagang,
    "is_staff": isStaff,
    "is_tentor": isTentor,
    "cuti": cuti,
    "cuti_magang": cutiMagang,
  };
}

class JumlahCuti {
  JumlahCuti({
    required this.jatahCuti,
    required this.bolehCuti,
    required this.jumlahCuti,
    required this.tahun,
  });

  final int jatahCuti;
  final bool bolehCuti;
  final int jumlahCuti;
  final String tahun;

  factory JumlahCuti.fromJson(Map<String, dynamic> json) => JumlahCuti(
    jatahCuti: json["jatah_cuti"],
    bolehCuti: json["boleh_cuti"],
    jumlahCuti: json["jumlah_cuti"],
    tahun: json["tahun"],
  );

  Map<String, dynamic> toJson() => {
    "jatah_cuti": jatahCuti,
    "boleh_cuti": bolehCuti,
    "jumlah_cuti": jumlahCuti,
    "tahun": tahun,
  };
}

Future<InsertCutiModel> loadPostCuti(String jsonData) async {
  String jsonPostCuti = jsonData;
  final jsonResponse = json.decode(jsonPostCuti);
  InsertCutiModel postCuti = new InsertCutiModel.fromJson(jsonResponse);
  return postCuti;
}