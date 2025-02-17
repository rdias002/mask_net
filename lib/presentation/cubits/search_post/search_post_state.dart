part of 'search_post_cubit.dart';

class SearchPostState extends Equatable {
  final bool isLoading;
  final String companyId;
  final List<Post>? posts;

  const SearchPostState({
    this.isLoading = false,
    this.companyId = '',
    this.posts,
  });

  @override
  List<Object> get props => [isLoading, companyId, posts ?? ''];

  SearchPostState copyWith({
    bool? isLoading,
    String? companyId,
    List<Post>? posts,
  }) {
    return SearchPostState(
      isLoading: isLoading ?? this.isLoading,
      companyId: companyId ?? this.companyId,
      posts: posts ?? this.posts,
    );
  }
}

class SearchPostError extends SearchPostState {
  final String message;

  SearchPostError(this.message, SearchPostState state)
      : super(
          isLoading: state.isLoading,
          posts: state.posts,
          companyId: state.companyId,
        );

  @override
  List<Object> get props => [Random()];
}
