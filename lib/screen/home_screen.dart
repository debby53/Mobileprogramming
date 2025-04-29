import 'package:flutter/material.dart';

class TodoItem {
  String title;
  String? description;
  bool isDone;

  TodoItem({required this.title, this.description, this.isDone = false});
}

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TodoItem> _todos = [];

  void _addTodo() {
    String title = '';
    String? description;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (val) => title = val,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              onChanged: (val) => description = val,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (title.trim().isNotEmpty) {
                setState(() {
                  _todos.add(TodoItem(title: title, description: description));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _toggleDone(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome, ${widget.userName}')),
      body: _todos.isEmpty
          ? const Center(child: Text('No todos yet! Tap "+" to add.'))
          : ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return Dismissible(
            key: Key(todo.title),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deleteTodo(index),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration:
                  todo.isDone ? TextDecoration.lineThrough : null,
                  color: todo.isDone ? Colors.grey : null,
                ),
              ),
              leading: Checkbox(
                value: todo.isDone,
                onChanged: (_) => _toggleDone(index),
              ),
              subtitle: todo.description != null
                  ? Text(todo.description!)
                  : null,
              onLongPress: () => _deleteTodo(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
