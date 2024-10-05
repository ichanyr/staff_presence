import 'dart:convert';

class Login {
  bool? status;
  String? message;
  String? idStaff;

  Login({this.status, this.message, this.idStaff});

  Login.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    idStaff = json['id_staff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['id_staff'] = this.idStaff;
    return data;
  }
}

Future<Login> cekAuth(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  Login login = new Login.fromJson(jsonResponse);
  return login;
}
