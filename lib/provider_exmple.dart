import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderExmple extends StatelessWidget {
  int count = 1;
  ProviderExmple({super.key});

  @override
  Widget build(BuildContext context) {
    final _textFieldController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('State Management - Provider'),
      ),
      body: ListView.builder(
        itemCount: context.watch<TodoNotifier>().getTodos.length,
        itemBuilder: (context, index) {
          Todo todo = context.watch<TodoNotifier>().getTodos[index];
          return GestureDetector(
            onTap: () {
              context.read<TodoNotifier>().deleteTodo(todo);
            },
            onLongPress: () async {
              await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('TextField in Dialog'),
                  content: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: "Text Field in Dialog"),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text('OK'),
                      onPressed: () {
                        print(_textFieldController.text);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
              );
              context.read<TodoNotifier>().updateTodo(todo.id ?? 0, Todo(id: todo.id, desc: _textFieldController.text),);
            },
            child: ListTile(
              leading: Text(todo.id.toString()),
              title: Text(
                todo.desc ?? "",
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('TextField in Dialog'),
                content: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: "Text Field in Dialog"),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      print(_textFieldController.text);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
          context
              .read<TodoNotifier>()
              .addTodo(Todo(id: count++, desc: _textFieldController.text));
        },
      ),
    );
  }
}

class Todo {
  int? id;
  String? desc;
  Todo({
    required this.id,
    required this.desc,
  });
}

class TodoNotifier with ChangeNotifier {
  List<Todo> todos = [];
  List<Todo> get getTodos => todos;

  addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  updateTodo(int index, Todo todo) {
    todos.insert(index, todo);
    notifyListeners();
  }

  deleteTodo(Todo todo) {
    todos.remove(todo);
    notifyListeners();
  }
}
