// To parse this JSON data, do
//
//     final responseSetToken = responseSetTokenFromJson(jsonString);

import 'dart:convert';

class ResponseSetTokenFcm {
  final bool status;
  final String message;

  ResponseSetTokenFcm({
    required this.status,
    required this.message,
  });

  factory ResponseSetTokenFcm.fromRawJson(String str) => ResponseSetTokenFcm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseSetTokenFcm.fromJson(Map<String, dynamic> json) => ResponseSetTokenFcm(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
