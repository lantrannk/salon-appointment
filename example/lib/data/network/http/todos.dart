import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/todo.dart';

class HttpTodos {
  static const String url = 'https://jsonplaceholder.typicode.com/todos';
  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse(url));
      List<Todo> todosList = [];

      if (response.statusCode == 200) {
        todosList = (json.decode(response.body) as List)
            .map((e) => Todo.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return todosList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
