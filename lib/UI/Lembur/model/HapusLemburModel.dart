import 'dart:convert';

class HapusLemburModel {
  HapusLemburModel({
    required this.status,
    required this.message,
  });
  late final bool status;
  late final String message;

  HapusLemburModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = message;
    return _data;
  }
}

HapusLemburModel hapusLemburModelFromJson(String str) => HapusLemburModel.fromJson(json.decode(str));

String hapusLemburModelToJson(HapusLemburModel data) => json.encode(data.toJson());

Future<HapusLemburModel> loadHapusLembur(String jsonData) async {
  String jsonGetLembur = jsonData;
  final jsonResponse = json.decode(jsonGetLembur);
  HapusLemburModel delLembur = new HapusLemburModel.fromJson(jsonResponse);
  return delLembur;
}