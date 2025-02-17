part of 'view_post_cubit.dart';

class ViewPostState extends Equatable {
  final bool isLoading;
  final Post? post;

  const ViewPostState({
    this.isLoading = false,
    this.post,
  });

  @override
  List<Object> get props => [isLoading, post ?? ''];

  ViewPostState copyWith({
    bool? isLoading,
    Post? post,
  }) {
    return ViewPostState(
      isLoading: isLoading ?? this.isLoading,
      post: post ?? this.post,
    );
  }
}

class ViewPostError extends ViewPostState {
  final String message;

  ViewPostError(this.message, ViewPostState state)
      : super(isLoading: state.isLoading, post: state.post);

  @override
  List<Object> get props => [Random()];
}
