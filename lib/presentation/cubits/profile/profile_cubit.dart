import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/result.dart';
import '../../../data/auth_repo.dart';
import '../../../data/model/post.dart';
import '../../../data/post_repo.dart';
import '../../model/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepo _authRepo;
  final PostRepo _postRepo;
  ProfileCubit(this._authRepo, this._postRepo) : super(const ProfileState());

  Future<void> getUserProfile() async {
    emit(state.copyWith(isLoading: true));

    try {
      final userProfile = await _authRepo.getUserProfile();
      if (userProfile is ResultFailed) {
        emit(ProfileError(userProfile.error!.message, state));
        return;
      }
      emit(state.copyWith(userProfile: userProfile.data, isLoading: false));
      getPosts();
    } catch (e) {
      emit(ProfileError('An error occurred. Please try again.', state));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulate a network call
      await _authRepo.logout();
      emit(const ProfileLogout());
    } catch (e) {
      emit(ProfileError('An error occurred. Please try again.', state));
    }
  }

  Future<void> getPosts() async {
    emit(state.copyWith(isLoading: true));

    try {
      final posts = await _postRepo.getPosts(
          userId: state.userProfile?.username ?? 'nan');
      if (posts is ResultFailed) {
        emit(ProfileError(posts.error!.message, state));
        return;
      }
      emit(state.copyWith(userPosts: posts.data, isLoading: false));
    } catch (e) {
      emit(ProfileError('An error occurred. Please try again.', state));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final result = await _postRepo.addPostClap(postId);
      if (result is ResultFailed) {
        emit(ProfileError(result.error.message, state));
        return;
      }

      emit(state.copyWith(
        userPosts: state.userPosts
            ?.map(
              (e) => e.postId == postId ? e.copyWith(claps: e.claps + 1) : e,
            )
            .toList(),
      ));
    } catch (e) {
      emit(ProfileError('An error occurred. Please try again.', state));
    }
  }

  Future<void> selectPollOption(String postId, int optionId) async {
    try {
      final result = await _postRepo.selectPollOption(postId, optionId);
      if (result is ResultFailed) {
        emit(ProfileError(result.error!.message, state));
        return;
      }
      emit(state.copyWith(
        userPosts: state.userPosts
            ?.map(
              (e) => e is PollPost && e.postId == postId
                  ? e.copyWith(votes: result.data)
                  : e,
            )
            .toList(),
      ));
    } catch (e) {
      emit(ProfileError('An error occurred. Please try again.', state));
    }
  }
}
