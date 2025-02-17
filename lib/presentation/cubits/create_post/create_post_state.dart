part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  final bool isLoading;
  final String postType;
  final String imageUrl;
  final List<String> polls;

  const CreatePostState(
      {this.isLoading = false,
      this.postType = textPostType,
      this.imageUrl = '',
      this.polls = const []});

  @override
  List<Object> get props => [isLoading, postType, imageUrl, polls];

  CreatePostState copyWith({
    bool? isLoading,
    String? postType,
    String? imageUrl,
    List<String>? polls,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      postType: postType ?? this.postType,
      imageUrl: imageUrl ?? this.imageUrl,
      polls: polls ?? this.polls,
    );
  }
}

class CreatePostError extends CreatePostState {
  final String message;

  const CreatePostError(this.message);

  @override
  List<Object> get props => [Random()];
}

class CreatePostSuccess extends CreatePostState {
  final String postId;
  const CreatePostSuccess(this.postId);

  @override
  List<Object> get props => [];
}
