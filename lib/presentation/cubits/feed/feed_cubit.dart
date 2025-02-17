import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/result.dart';
import '../../../data/model/post.dart';
import '../../../data/post_repo.dart';

part 'feed_state.dart';

class HomeFeedCubit extends Cubit<HomeFeedState> {
  final PostRepo _postRepo;
  HomeFeedCubit(this._postRepo) : super(const HomeFeedState());

  Future<void> getPosts() async {
    emit(state.copyWith(isLoading: true));

    try {
      final posts = await _postRepo.getPosts();
      if (posts is ResultFailed) {
        emit(FeedError(posts.error!.message));
        return;
      }
      emit(state.copyWith(posts: posts.data, isLoading: false));
    } catch (e) {
      emit(const FeedError('An error occurred. Please try again.'));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final result = await _postRepo.addPostClap(postId);
      if (result is ResultFailed) {
        emit(FeedError(
          result.error.message,
        ));
        return;
      }

      emit(state.copyWith(
        posts: state.posts
            ?.map(
              (e) => e.postId == postId ? e.copyWith(claps: e.claps + 1) : e,
            )
            .toList(),
      ));
    } catch (e) {
      emit(FeedError('An error occurred. Please try again.'));
    }
  }

  Future<void> selectPollOption(String postId, int optionId) async {
    try {
      final result = await _postRepo.selectPollOption(postId, optionId);
      if (result is ResultFailed) {
        emit(FeedError(
          result.error!.message,
        ));
        return;
      }
      emit(state.copyWith(
        posts: state.posts
            ?.map(
              (e) => e is PollPost && e.postId == postId
                  ? e.copyWith(votes: result.data)
                  : e,
            )
            .toList(),
      ));
    } catch (e) {
      emit(FeedError(
        'An error occurred. Please try again.',
      ));
    }
  }
}
