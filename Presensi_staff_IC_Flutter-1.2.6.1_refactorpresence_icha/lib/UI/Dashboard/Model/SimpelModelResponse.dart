import 'dart:convert';

class SimpleModelResponse {
  late bool status;
  late String message;

  SimpleModelResponse({required this.status, required this.message});

  SimpleModelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    data['msg'] = this.message;
    return data;
  }
}

Future<SimpleModelResponse> loadResponse(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  SimpleModelResponse dashboard = new SimpleModelResponse.fromJson(jsonResponse);
  return dashboard;
}
