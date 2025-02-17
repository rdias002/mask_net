class PostComment {
  final String id;
  final String body;
  final String author;
  final DateTime date;

  PostComment({
    required this.id,
    required this.body,
    required this.author,
    required this.date,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'],
      body: json['body'],
      author: json['author'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'author': author,
      'date': date.toIso8601String(),
    };
  }

  PostComment copyWith({
    String? id,
    String? body,
    String? author,
    DateTime? date,
  }) {
    return PostComment(
      id: id ?? this.id,
      body: body ?? this.body,
      author: author ?? this.author,
      date: date ?? this.date,
    );
  }
}
