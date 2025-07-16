class Task {
  static final String idColumn = 'id';
  static final String titleColumn = 'title';
  static final String descriptionColumn = 'description';
  static final String doneColumn = 'done';
  static final String taskTypeColumn = 'taskType';

  final int? id;
  final String title;
  final String? description;
  final bool done;
  final TaskType taskType;

  Task(
      {required this.title,
      this.description,
      this.id,
      this.done = false,
      required this.taskType});

  Map<String, dynamic> toMap() => {
        idColumn: id,
        titleColumn: title,
        descriptionColumn: description,
        doneColumn: done ? 1 : 0,
        taskTypeColumn: taskType.name
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
      title: map[titleColumn],
      id: map[idColumn],
      description: map[descriptionColumn],
      done: map[doneColumn] == 1,
      taskType: TaskType.getTypeFromName(map[taskTypeColumn]));

  Task copyWith(
      {int? id,
      String? title,
      String? description,
      bool? done,
      TaskType? taskType}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        done: done ?? this.done,
        taskType: taskType ?? this.taskType);
  }

  @override
  String toString() {
    return 'Task(id, $id, title: $title, description: $description, done: $done, taskType: ${taskType.name}';
  }
}

enum TaskType {
  important('important', 'Important'),
  selfCare('selfCare', 'Self care');

  final String _name;
  final String _label;

  String get name => _name.toLowerCase().trim();
  String get label => _label;

  const TaskType(this._name, this._label);

  static TaskType getTypeFromName(String name) {
    final cleanName = name.trim().toLowerCase();
    for (final TaskType type in TaskType.values) {
      if (type.name == cleanName) return type;
    }
    throw Exception('Task type not found : $name');
  }
}
