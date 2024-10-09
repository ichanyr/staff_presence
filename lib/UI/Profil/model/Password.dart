import 'dart:convert';

class ResponUpdatePassword {
  bool? status;
  String? message;

  ResponUpdatePassword({this.status, this.message});

  ResponUpdatePassword.fromJson(Map<String, dynamic> json) {
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

Future<ResponUpdatePassword> responsePutPass(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  ResponUpdatePassword response = new ResponUpdatePassword.fromJson(jsonResponse);
  return response;
}

Future<ResponUpdatePassword> responseLupaPass(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  ResponUpdatePassword response = new ResponUpdatePassword.fromJson(jsonResponse);
  return response;
}