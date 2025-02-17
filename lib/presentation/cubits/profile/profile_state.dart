part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final UserProfile? userProfile;
  final List<Post>? userPosts;
  final bool isLoading;

  const ProfileState({
    this.userProfile,
    this.userPosts,
    this.isLoading = false,
  });

  ProfileState copyWith({
    UserProfile? userProfile,
    List<Post>? userPosts,
    bool? isLoading,
  }) {
    return ProfileState(
      userPosts: userPosts ?? this.userPosts,
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [userProfile ?? '', userPosts ?? [], isLoading];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message, ProfileState state)
      : super(
          userProfile: state.userProfile,
          userPosts: state.userPosts,
          isLoading: state.isLoading,
        );

  @override
  List<Object> get props => [message, Random()];
}

class ProfileLogout extends ProfileState {
  const ProfileLogout();

  @override
  List<Object> get props => [Random()];
}
