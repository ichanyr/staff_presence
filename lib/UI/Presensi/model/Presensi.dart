import 'dart:convert';

class PresensiQr {
  bool? status;
  String? message;
  String? msgPoin;
  bool? statusLembur;

  PresensiQr({this.status, this.message, this.msgPoin, this.statusLembur});

  PresensiQr.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    msgPoin = json['msg_poin'] ?? '';
    statusLembur = json['status_lembur'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['msg_poin'] = this.msgPoin;
    data['status_lembur'] = this.statusLembur;
    return data;
  }
}

Future<PresensiQr> loadResponPresensi(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  PresensiQr presensiQr = new PresensiQr.fromJson(jsonResponse);
  return presensiQr;
}