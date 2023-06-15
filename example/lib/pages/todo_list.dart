import 'dart:async';

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

  final todosStream = StreamController<List<Todo>>();

  Future<void> fetchTodos() async {
    final todos = await httpTodos.fetchTodos();
    todosStream.sink.add(todos);
  }

  @override
  void initState() {
    httpUsers.fetchUsers().then((value) => _users = value);
    fetchTodos();
    option = 'all';
    super.initState();
  }

  @override
  void dispose() {
    todosStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: todosStream.stream,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                return Dismissible(
                  key: ValueKey<Todo>(todos[index]),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) async {
                    await httpTodos.deleteTodo(index.toString());
                  },
                  child: TodoListItem(
                    todo: todos[index],
                    user:
                        _users.where((e) => e.id == todos[index].userId).first,
                    onChanged: (value) async {
                      Todo todo = todos[index];

                      setState(() {
                        todo.completed = value!;
                      });

                      await httpTodos.updateTodo(todo);
                    },
                  ),
                );
              }),
            ),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: const Center(
            child: CircularProgressIndicator(),
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
    this.onChanged,
    super.key,
  });

  final Todo todo;
  final User user;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    bool completed = todo.completed;

    return Padding(
      padding: const EdgeInsets.all(4),
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
          value: completed,
          onChanged: onChanged,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
