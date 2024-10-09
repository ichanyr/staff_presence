// To parse this JSON data, do
//
//     final cutiModel = cutiModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CutiModel cutiModelFromJson(String str) => CutiModel.fromJson(json.decode(str));

String cutiModelToJson(CutiModel data) => json.encode(data.toJson());

class CutiModel {
  CutiModel({
    required this.status,
    required this.message,
    required this.jatahCuti,
    required this.sum,
    required this.izin,
  });

  final bool status;
  final String message;
  final List<JatahCuti> jatahCuti;
  final Sum sum;
  final List<Izin> izin;

  factory CutiModel.fromJson(Map<String, dynamic> json) => CutiModel(
    status: json["status"],
    message: json["message"],
    jatahCuti: List<JatahCuti>.from(json["jatah_cuti"].map((x) => JatahCuti.fromJson(x))),
    sum: Sum.fromJson(json["sum"]),
    izin: List<Izin>.from(json["izin"].map((x) => Izin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "jatah_cuti": List<dynamic>.from(jatahCuti.map((x) => x.toJson())),
    "sum": sum.toJson(),
    "izin": List<dynamic>.from(izin.map((x) => x.toJson())),
  };
}

class Izin {
  Izin({
    required this.idStaff,
    required this.name,
    required this.izin,
    required this.status,
    required this.mulai,
    required this.berapaHari,
    required this.id
  });

  final String idStaff;
  final String name;
  final String izin;
  final String id;
  final String status;
  final DateTime mulai;
  final String berapaHari;

  factory Izin.fromJson(Map<String, dynamic> json) => Izin(
    idStaff: json["id_staff"],
    name: json["name"],
    izin: json["izin"],
    id: json["id"],
    status: json["status"],
    mulai: DateTime.parse(json["mulai"]),
    berapaHari: json["berapa_hari"],
  );

  Map<String, dynamic> toJson() => {
    "id_staff": idStaff,
    "name": name,
    "id": id,
    "izin": izin,
    "status": status,
    "mulai": mulai.toIso8601String(),
    "berapa_hari": berapaHari,
  };
}

enum Name { TRI_TENTOR }

enum Status { P, A, R }

class JatahCuti {
  JatahCuti({
    required this.idStaff,
    required this.name,
    required this.cabang,
    required this.isMagang,
    required this.isStaff,
    required this.cuti,
    required this.cutiMagang,
  });

  final String idStaff;
  final String name;
  final String cabang;
  final String isMagang;
  final String isStaff;
  final String cuti;
  final String cutiMagang;

  factory JatahCuti.fromJson(Map<String, dynamic> json) => JatahCuti(
    idStaff: json["id_staff"],
    name: json["name"],
    cabang: json["cabang"],
    isMagang: json["is_magang"],
    isStaff: json["is_staff"],
    cuti: json["cuti"],
    cutiMagang: json["cuti_magang"],
  );

  Map<String, dynamic> toJson() => {
    "id_staff": idStaff,
    "name": name,
    "cabang": cabang,
    "is_magang": isMagang,
    "is_staff": isStaff,
    "cuti": cuti,
    "cuti_magang": cutiMagang,
  };
}

class Sum {
  Sum({
    required this.sakit,
    required this.izin,
    required this.alpha,
    required this.cuti,
  });

  final String sakit;
  final String izin;
  final String alpha;
  final String cuti;

  factory Sum.fromJson(Map<String, dynamic> json) => Sum(
    sakit: json["sakit"],
    izin: json["izin"],
    alpha: json["alpha"],
    cuti: json["cuti"],
  );

  Map<String, dynamic> toJson() => {
    "sakit": sakit,
    "izin": izin,
    "alpha": alpha,
    "cuti": cuti,
  };
}

Future<CutiModel> loadGetCuti(String jsonData) async {
  String jsonGetCuti = jsonData;
  final jsonResponse = json.decode(jsonGetCuti);
  CutiModel getCuti = new CutiModel.fromJson(jsonResponse);
  return getCuti;
}