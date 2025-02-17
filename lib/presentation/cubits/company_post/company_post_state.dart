part of 'company_post_cubit.dart';

class CompanyPostState extends Equatable {
  final bool isLoading;
  final String companyId;
  final Company? company;
  final List<Post>? posts;

  const CompanyPostState({
    this.isLoading = false,
    this.companyId = '',
    this.posts,
    this.company,
  });

  @override
  List<Object> get props => [isLoading, companyId, posts ?? '', company ?? ''];

  CompanyPostState copyWith({
    bool? isLoading,
    String? companyId,
    Company? company,
    List<Post>? posts,
  }) {
    return CompanyPostState(
      isLoading: isLoading ?? this.isLoading,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      posts: posts ?? this.posts,
    );
  }
}

class CompanyPostError extends CompanyPostState {
  final String message;

  CompanyPostError(this.message, CompanyPostState state)
      : super(
            isLoading: state.isLoading,
            posts: state.posts,
            companyId: state.companyId,
            company: state.company);

  @override
  List<Object> get props => [Random()];
}
