class Chapter {
  const Chapter({required this.id, required this.title, required this.completed});

  final String id;
  final String title;
  final bool completed;

  Chapter copyWith({bool? completed}) => Chapter(
        id: id,
        title: title,
        completed: completed ?? this.completed,
      );

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json['id'] as String,
        title: json['chapter'] as String,
        completed: json['completed'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapter': title,
        'completed': completed,
      };
}
