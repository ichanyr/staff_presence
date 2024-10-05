import 'dart:convert';

class TambahLemburModel {
  TambahLemburModel({
    required this.status,
    required this.message,
  });
  late final bool status;
  late final String message;

  TambahLemburModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    return _data;
  }
}

TambahLemburModel lemburModelFromJson(String str) => TambahLemburModel.fromJson(json.decode(str));

String tambahLemburModelToJson(TambahLemburModel data) => json.encode(data.toJson());

Future<TambahLemburModel> loadTambahLembur(String jsonData) async {
  String jsonGetLembu = jsonData;
  final jsonResponse = json.decode(jsonGetLembu);
  TambahLemburModel getTambahLembur = new TambahLemburModel.fromJson(jsonResponse);
  return getTambahLembur;
}