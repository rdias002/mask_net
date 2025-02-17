import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/result.dart';
import '../../../data/model/post.dart';
import '../../../data/post_repo.dart';

part 'search_post_state.dart';

class SearchPostCubit extends Cubit<SearchPostState> {
  final PostRepo _postRepo;
  final String companyId;
  SearchPostCubit(this._postRepo, this.companyId)
      : super(const SearchPostState());

  Future<void> searchPosts(String query) async {
    if (query.length < 3) return;

    emit(state.copyWith(isLoading: true));

    try {
      final posts = await _postRepo.searchPosts(
          searchQuery: query, companyId: state.companyId);
      if (posts is ResultFailed) {
        emit(SearchPostError(posts.error!.message, state));
        return;
      }
      emit(state.copyWith(posts: posts.data, isLoading: false));
    } catch (e) {
      emit(SearchPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final result = await _postRepo.addPostClap(postId);
      if (result is ResultFailed) {
        emit(SearchPostError(result.error.message, state));
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
      emit(SearchPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> selectPollOption(String postId, int optionId) async {
    try {
      final result = await _postRepo.selectPollOption(postId, optionId);
      if (result is ResultFailed) {
        emit(SearchPostError(result.error!.message, state));
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
      emit(SearchPostError('An error occurred. Please try again.', state));
    }
  }
}
