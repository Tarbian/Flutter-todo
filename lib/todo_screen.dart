import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}



class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textEditingController = TextEditingController();
  int _themeValue = 2;
  late FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _loadTasks(); 
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tasks = prefs.getStringList('tasks');

    if (tasks != null) {
      setState(() {
        _todos.clear();
        _todos.addAll(tasks.map((task) => TodoItem.fromJson(task)));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> taskStrings =
        _todos.map((task) => task.toJson()).toList();
    prefs.setStringList('tasks', taskStrings);
  }

  void _addTodo() {
    String todoText = _textEditingController.text;
    if (todoText.isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(text: todoText, completed: false));
        _textEditingController.clear();
        _saveTasks();
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].completed = !_todos[index].completed;
      _saveTasks();
    });
  }

  void _themeChangeCallback(int index) {
    setState(() {
      switch (index) {
        case 1:
          AdaptiveTheme.of(context).setLight();
        case 2:
          AdaptiveTheme.of(context).setDark();
        case 3:
          AdaptiveTheme.of(context).setSystem();
        default:
      }
      _themeValue = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text('Light theme'),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text('Dark theme'),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text('System theme'),
              ),
            ],
            value: _themeValue,
            onChanged: (value) => _themeChangeCallback(value!),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    focusNode: _textFocusNode,
                    onSubmitted: (_) {
                      _addTodo();
                      _textFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'Enter your todo',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _toggleTodo(index),
                  title: Text(
                    _todos[index].text,
                    style: _todos[index].completed
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  leading: Checkbox(
                    value: _todos[index].completed,
                    onChanged: (bool? value) => _toggleTodo(index),
                  ),
                  trailing: IconButton(
                    color: Colors.red[300],
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTodo(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
