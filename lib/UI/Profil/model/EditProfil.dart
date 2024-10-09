import 'dart:convert';

class ProfilEdit {
  bool? status;
  String? message;

  ProfilEdit({this.status, this.message});

  ProfilEdit.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

Future<ProfilEdit> loadRspnsProfil(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  ProfilEdit profilEdit = new ProfilEdit.fromJson(jsonResponse);
  return profilEdit;
}