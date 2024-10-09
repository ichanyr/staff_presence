import 'dart:convert';

enum TodoActPostTypes { post, put, delete, putStatus }

class TodoActPostType {
  final TodoActPostTypes todoActPostTypes;

  TodoActPostType(this.todoActPostTypes);
}

class TodoAct {
  bool? status;
  String? message;

  TodoAct({this.status, this.message});

  TodoAct.fromJson(Map<String, dynamic> json) {
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

Future<TodoAct> loadTodo(String jsonData) async {
  String jsonProduct = jsonData;
  final jsonResponse = json.decode(jsonProduct);
  TodoAct todoAct = new TodoAct.fromJson(jsonResponse);
  return todoAct;
}
