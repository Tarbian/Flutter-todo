class TodoItem {
  String text;
  bool completed;

  TodoItem({required this.text, required this.completed});

  TodoItem.fromJson(String json)
      : text = json.split('||')[0],
        completed = json.split('||')[1] == 'true';

  String toJson() => '$text||$completed';
}