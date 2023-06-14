import 'package:example/data/network/http/todos.dart';
import 'package:example/data/network/http/users.dart';
import 'package:flutter/material.dart';

import '../data/models/todo.dart';
import '../data/models/user.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final httpTodos = HttpTodos();
  final httpUsers = HttpUsers();
  late final List<User> _users;
  late String option;

  @override
  void initState() {
    httpUsers.fetchUsers().then((value) => _users = value);
    option = 'all';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: httpTodos.fetchTodos(),
      builder: (context, snapshot) {
        List<Todo> todos = [];
        if (snapshot.hasData) {
          switch (option) {
            case 'all':
              todos = snapshot.data!;
              break;
            case 'completed':
              todos = snapshot.data!.where((e) => e.completed == true).toList();
              break;
            case 'incomplete':
              todos =
                  snapshot.data!.where((e) => e.completed == false).toList();
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'HTTP example',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6F00),
                ),
              ),
              backgroundColor: const Color(0xFFFFCC80),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    switch (option) {
                      case 'all':
                        setState(() {
                          option = 'completed';
                        });
                        break;
                      case 'completed':
                        setState(() {
                          option = 'incomplete';
                        });

                        break;
                      case 'incomplete':
                        setState(() {
                          option = 'all';
                        });

                        break;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.filter_list),
                      Text(option),
                    ],
                  ),
                ),
              ],
            ),
            body: ListView.builder(
              itemBuilder: ((context, index) {
                return TodoListItem(
                  todo: todos[index],
                  user: _users.where((e) => e.id == todos[index].userId).first,
                );
              }),
            ),
          );
        }
        return Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    required this.todo,
    required this.user,
    super.key,
  });

  final Todo todo;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          '${todo.id}',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        title: Text(
          todo.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.name),
        trailing: Checkbox(
          value: todo.completed,
          onChanged: null,
        ),
      ),
    );
  }
}
