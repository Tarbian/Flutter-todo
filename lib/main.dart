import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: const TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class TodoItem {
  String text;
  bool completed;

  TodoItem({required this.text, required this.completed});
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textEditingController = TextEditingController();
  int _themeValue = 2;

  void _addTodo() {
    setState(() {
      String todoText = _textEditingController.text;
      if (todoText.isNotEmpty) {
        _todos.add(TodoItem(text: todoText, completed: false));
        _textEditingController.clear();
      }
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].completed = !_todos[index].completed;
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
