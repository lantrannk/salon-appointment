import 'dart:async';
import 'dart:math';

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
  final titleTextController = TextEditingController();
  final userTextController = TextEditingController();

  Future<void> fetchTodos() async {
    final todos = await httpTodos.fetchTodos();
    todosStream.sink.add(todos);
  }

  Future<void> fetchUsers() async {
    _users = await httpUsers.fetchUsers();
  }

  @override
  void initState() {
    fetchUsers();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: titleTextController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: userTextController,
                      decoration: const InputDecoration(
                        hintText: 'User Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final user = _users.where(
                            (e) => e.id.toString() == userTextController.text);

                        final todo = Todo(
                          id: (Random().nextInt(900) + 100).toString(),
                          userId: (user.isNotEmpty) ? user.first.id : 0,
                          title: titleTextController.text,
                          completed: false,
                        );
                        await httpTodos.addTodo(todo);
                        setState(() {
                          Navigator.pop(context);
                          fetchTodos();
                        });
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xFFFF6F00),
        elevation: 5,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 20,
        ),
      ),
      body: StreamBuilder(
        stream: todosStream.stream,
        builder: (context, snapshot) {
          List<Todo> todos = [];
          if (snapshot.hasData) {
            switch (option) {
              case 'all':
                todos = snapshot.data!;
                break;
              case 'completed':
                todos =
                    snapshot.data!.where((e) => e.completed == true).toList();
                break;
              case 'incomplete':
                todos =
                    snapshot.data!.where((e) => e.completed == false).toList();
                break;
            }

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: ((context, index) {
                Todo todo = todos[index];

                return Dismissible(
                  key: ValueKey<Todo>(todo),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) async {
                    setState(() {
                      todos.remove(todo);
                    });

                    await httpTodos.deleteTodo(todo.id);
                  },
                  child: TodoListItem(
                    todo: todo,
                    user: (todo.userId == 0)
                        ? null
                        : _users.where((e) => e.id == todo.userId).first,
                    onChanged: (value) async {
                      setState(() {
                        todo.completed = value!;
                      });

                      await httpTodos.updateTodo(todo);
                    },
                  ),
                );
              }),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
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
  final User? user;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    bool completed = todo.completed;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ListTile(
        leading: Text(
          todo.id,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        title: Text(
          todo.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user?.name ?? 'unknown',
          style: const TextStyle(
            color: Color(0xFF6A1B9A),
          ),
        ),
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
