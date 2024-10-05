import 'dart:convert';

class Qr {
  bool? status;
  Message? message;

  Qr({this.status, this.message});

  Qr.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  String? qrcode;
  String? latitude;
  String? longitude;

  Message({this.qrcode, this.latitude, this.longitude});

  Message.fromJson(Map<String, dynamic> json) {
    qrcode = json['qrcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qrcode'] = this.qrcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

Future<Qr> loadQr(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  Qr qr = new Qr.fromJson(jsonResponse);
  return qr;
}
