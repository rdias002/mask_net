import 'post_comment.dart';

const String textPostType = 'textPost';
const String imagePostType = 'imagePost';
const String pollPostType = 'pollPost';
const List<String> postTypes = [textPostType, imagePostType, pollPostType];

sealed class Post {
  final String postId;
  final String postTitle;
  final int claps;
  final List<PostComment> comments;
  final int commentCount;
  final String author;
  final String channelId;
  final DateTime dateOfCreation;

  const Post({
    required this.postId,
    required this.postTitle,
    required this.claps,
    required this.comments,
    required this.commentCount,
    required this.author,
    required this.channelId,
    required this.dateOfCreation,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'textPost':
        return TextPost.fromJson(json);
      case 'pollPost':
        return PollPost.fromJson(json);
      case 'imagePost':
        return ImagePost.fromJson(json);
      default:
        throw Exception('Unknown post type');
    }
  }

  Map<String, dynamic> toJson();
  Post copyWith(
      {String? postId,
      String? postTitle,
      int? claps,
      List<PostComment>? comments,
      int? commentCount,
      String? author,
      String? channelId,
      DateTime? dateOfCreation});
}

class TextPost extends Post {
  final String content;

  const TextPost({
    required super.postId,
    required super.postTitle,
    required super.claps,
    required super.comments,
    required super.commentCount,
    required super.author,
    required super.channelId,
    required super.dateOfCreation,
    required this.content,
  });

  factory TextPost.fromJson(Map<String, dynamic> json) {
    return TextPost(
      postId: json['postId'],
      postTitle: json['postTitle'],
      claps: json['claps'],
      comments: json['comments'] != null
          ? List<Map<String, dynamic>>.from(json['comments'])
              .map((e) => PostComment.fromJson(e))
              .toList()
          : [],
      commentCount: json['commentCount'] ?? 0,
      author: json['author'],
      channelId: json['channelId'],
      dateOfCreation: DateTime.parse(json['dateOfCreation']),
      content: json['content'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'textPost',
      'postId': postId,
      'postTitle': postTitle,
      'claps': claps,
      'author': author,
      'commentCount': commentCount,
      'channelId': channelId,
      'dateOfCreation': dateOfCreation.toIso8601String(),
      'content': content,
    };
  }

  @override
  TextPost copyWith({
    String? postId,
    String? postTitle,
    int? claps,
    List<PostComment>? comments,
    int? commentCount,
    String? author,
    String? channelId,
    DateTime? dateOfCreation,
    String? content,
  }) {
    return TextPost(
      postId: postId ?? this.postId,
      postTitle: postTitle ?? this.postTitle,
      claps: claps ?? this.claps,
      comments: comments ?? this.comments,
      commentCount: commentCount ?? this.commentCount,
      author: author ?? this.author,
      channelId: channelId ?? this.channelId,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
      content: content ?? this.content,
    );
  }
}

class PollPost extends Post {
  final List<String> options;
  final List<int> votes;

  const PollPost({
    required super.postId,
    required super.postTitle,
    required super.claps,
    required super.comments,
    required super.commentCount,
    required super.author,
    required super.channelId,
    required super.dateOfCreation,
    required this.options,
    required this.votes,
  });

  factory PollPost.fromJson(Map<String, dynamic> json) {
    return PollPost(
      postId: json['postId'],
      postTitle: json['postTitle'],
      claps: json['claps'],
      comments: json['comments'] != null
          ? List<Map<String, dynamic>>.from(json['comments'])
              .map((e) => PostComment.fromJson(e))
              .toList()
          : [],
      commentCount: json['commentCount'] ?? 0,
      author: json['author'],
      channelId: json['channelId'],
      dateOfCreation: DateTime.parse(json['dateOfCreation']),
      options: List<String>.from(json['options']),
      votes: List<int>.from(json['votes']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'pollPost',
      'postId': postId,
      'postTitle': postTitle,
      'claps': claps,
      'commentCount': commentCount,
      'author': author,
      'channelId': channelId,
      'dateOfCreation': dateOfCreation.toIso8601String(),
      'options': options,
      'votes': votes,
    };
  }

  @override
  PollPost copyWith({
    String? postId,
    String? postTitle,
    int? claps,
    List<PostComment>? comments,
    int? commentCount,
    String? author,
    String? channelId,
    DateTime? dateOfCreation,
    List<String>? options,
    List<int>? votes,
  }) {
    return PollPost(
      postId: postId ?? this.postId,
      postTitle: postTitle ?? this.postTitle,
      claps: claps ?? this.claps,
      comments: comments ?? this.comments,
      commentCount: commentCount ?? this.commentCount,
      author: author ?? this.author,
      channelId: channelId ?? this.channelId,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
      options: options ?? this.options,
      votes: votes ?? this.votes,
    );
  }
}

class ImagePost extends Post {
  final String imageUrl;

  const ImagePost({
    required super.postId,
    required super.postTitle,
    required super.claps,
    required super.comments,
    required super.commentCount,
    required super.author,
    required super.channelId,
    required super.dateOfCreation,
    required this.imageUrl,
  });

  factory ImagePost.fromJson(Map<String, dynamic> json) {
    return ImagePost(
      postId: json['postId'],
      postTitle: json['postTitle'],
      claps: json['claps'],
      comments: json['comments'] != null
          ? List<Map<String, dynamic>>.from(json['comments'])
              .map((e) => PostComment.fromJson(e))
              .toList()
          : [],
      commentCount: json['commentCount'] ?? 0,
      author: json['author'],
      channelId: json['channelId'],
      dateOfCreation: DateTime.parse(json['dateOfCreation']),
      imageUrl: json['imageUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'imagePost',
      'postId': postId,
      'postTitle': postTitle,
      'claps': claps,
      'commentCount': commentCount,
      'author': author,
      'channelId': channelId,
      'dateOfCreation': dateOfCreation.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  @override
  ImagePost copyWith({
    String? postId,
    String? postTitle,
    int? claps,
    List<PostComment>? comments,
    int? commentCount,
    String? author,
    String? channelId,
    DateTime? dateOfCreation,
    String? imageUrl,
  }) {
    return ImagePost(
      postId: postId ?? this.postId,
      postTitle: postTitle ?? this.postTitle,
      claps: claps ?? this.claps,
      comments: comments ?? this.comments,
      commentCount: commentCount ?? this.commentCount,
      author: author ?? this.author,
      channelId: channelId ?? this.channelId,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
