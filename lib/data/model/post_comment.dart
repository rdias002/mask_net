class PostComment {
  final String id;
  final String body;
  final String author;
  final int claps;
  final DateTime date;

  PostComment({
    required this.id,
    required this.body,
    required this.author,
    required this.claps,
    required this.date,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'],
      body: json['body'],
      author: json['author'],
      claps: json['claps'] ?? 0,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'author': author,
      'claps': claps,
      'date': date.toIso8601String(),
    };
  }

  PostComment copyWith({
    String? id,
    String? body,
    String? author,
    int? claps,
    DateTime? date,
  }) {
    return PostComment(
      id: id ?? this.id,
      body: body ?? this.body,
      author: author ?? this.author,
      claps: claps ?? this.claps,
      date: date ?? this.date,
    );
  }
}
