part of 'feed_cubit.dart';

class HomeFeedState extends Equatable {
  final bool isLoading;
  final List<Post>? posts;

  const HomeFeedState({
    this.isLoading = false,
    this.posts,
  });

  @override
  List<Object> get props => [isLoading, posts ?? ''];

  HomeFeedState copyWith({
    bool? isLoading,
    List<Post>? posts,
  }) {
    return HomeFeedState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
    );
  }
}

class FeedError extends HomeFeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object> get props => [Random()];
}

class FeedSuccess extends HomeFeedState {
  final String postId;
  const FeedSuccess(this.postId);

  @override
  List<Object> get props => [];
}
