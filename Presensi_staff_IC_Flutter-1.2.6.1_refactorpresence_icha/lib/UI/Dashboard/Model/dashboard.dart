import 'dart:convert';

class DashboardModel {
  late bool status;
  late Message message;

  DashboardModel({required this.status, required this.message});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    data['message'] = this.message.toJson();
    return data;
  }
}

class Message {
  late String id;
  late String poin;
  late String lastTglMasuk;
  late String lastJamMasuk;
  late String lastJamKeluar;

  Message(
      {required this.id,
      required this.poin,
      required this.lastTglMasuk,
      required this.lastJamMasuk,
      required this.lastJamKeluar});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    poin = json['poin'];
    lastTglMasuk = json['last_tgl_masuk'] ?? '';
    lastJamMasuk = json['last_jam_masuk'] ?? '';
    lastJamKeluar = json['last_jam_keluar'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['poin'] = this.poin;
    data['last_tgl_masuk'] = this.lastTglMasuk;
    data['last_jam_masuk'] = this.lastJamMasuk;
    data['last_jam_keluar'] = this.lastJamKeluar;
    return data;
  }
}

Future<DashboardModel> loadPoin(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  DashboardModel dashboard = new DashboardModel.fromJson(jsonResponse);
  return dashboard;
}
