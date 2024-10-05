import 'dart:convert';

LemburModel lemburModelFromJson(String str) => LemburModel.fromJson(json.decode(str));

String lemburModelToJson(LemburModel data) => json.encode(data.toJson());

class LemburModel {
  LemburModel({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });
  late final bool status;
  late final String message;
  late final List<DataLembur> data;
  late final int count;

  LemburModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>DataLembur.fromJson(e)).toList();
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['count'] = count;
    return _data;
  }
}

class DataLembur {
  DataLembur({
    required this.idLembur,
    required this.mulai,
    required this.selesai,
    required this.totalJam,
    required this.keterangan,
    required this.status,
    required this.masukan,
    required this.isAktif,
    required this.presensiId,
    required this.createdAt,
    required this.createdBy,
  });
  late final String idLembur;
  late final DateTime mulai;
  late final DateTime selesai;
  late final String totalJam;
  late final String keterangan;
  late final String status;
  late final String masukan;
  late final String isAktif;
  late final String presensiId;
  late final DateTime createdAt;
  late final String createdBy;

  DataLembur.fromJson(Map<String, dynamic> json){
    idLembur = json['id_lembur'];
    mulai = DateTime.parse(json['mulai']);
    selesai = DateTime.parse(json['selesai']);
    totalJam = json['total_jam'];
    keterangan = json['keterangan'] ?? '';
    status = json['status'];
    masukan = json['masukan'] ?? '';
    isAktif = json['is_aktif'];
    presensiId = json['presensi_id'];
    createdAt = DateTime.parse(json['created_at']);
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_lembur'] = idLembur;
    _data['mulai'] = mulai;
    _data['selesai'] = selesai;
    _data['total_jam'] = totalJam;
    _data['keterangan'] = keterangan;
    _data['status'] = status;
    _data['masukan'] = masukan;
    _data['is_aktif'] = isAktif;
    _data['presensi_id'] = presensiId;
    _data['created_at'] = createdAt;
    _data['created_by'] = createdBy;
    return _data;
  }
}

Future<LemburModel> loadLembur(String jsonData) async {
  String jsonGetLembu = jsonData;
  final jsonResponse = json.decode(jsonGetLembu);
  LemburModel getLembur = new LemburModel.fromJson(jsonResponse);
  return getLembur;
}