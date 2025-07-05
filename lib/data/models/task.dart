class Task {
  static final String idColumn = 'id';
  static final String titleColumn = 'title';
  static final String descriptionColumn = 'description';
  static final String doneColumn = 'done';

  final int? id;
  final String title;
  final String description;
  final bool done;

  Task(
      {required this.title,
      this.description = "No description for this task. Lorem ipsum set dolor amet mess couilles, oui oui oui ta mère la reine des tchoins ca me casse les couilles putehue",
      this.id,
      this.done = false});

  Task.id(this.id, this.title,
      {this.description = "No description for this task. Lorem ipsum set dolor amet mess couilles, oui oui oui ta mère la reine des tchoins ca me casse les couilles putehue", this.done = false});

  Map<String, dynamic> toMap() => {
        idColumn: id,
        titleColumn: title,
        descriptionColumn: description,
        doneColumn: done ? 1 : 0
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
      title: map[titleColumn],
      id: map[idColumn],
      description: map[descriptionColumn],
      done: map[doneColumn] == 1);

  Task copyWith({int? id, String? title, String? description, bool? done}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        done: done ?? this.done);
  }

  @override
  String toString() {
    return 'Task(id, $id, title: $title, description: $description, done: $done';
  }
}
