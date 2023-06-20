import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/todo.dart';

class HttpTodos {
  final String baseUrl = 'https://648ae68b17f1536d65e9ecfd.mockapi.io/todos';

  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<List<Todo>> fetchTodos() async {
    final Uri url = Uri.parse(baseUrl);
    try {
      final response = await http.get(url);
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

  Future<void> addTodo(Todo todo) async {
    final Uri url = Uri.parse(baseUrl);
    try {
      await http.post(
        url,
        headers: headers,
        body: json.encode(todo.toJson()),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final Uri url = Uri.parse('$baseUrl/${todo.id}');
    try {
      await http.put(
        url,
        headers: headers,
        body: json.encode(todo.toJson()),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTodo(String todoId) async {
    final Uri url = Uri.parse('$baseUrl/$todoId');
    try {
      await http.delete(url);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
