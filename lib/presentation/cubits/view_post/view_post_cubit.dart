import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/result.dart';
import '../../../data/model/post.dart';
import '../../../data/post_repo.dart';

part 'view_post_state.dart';

class ViewPostCubit extends Cubit<ViewPostState> {
  final PostRepo _postRepo;
  ViewPostCubit(this._postRepo) : super(const ViewPostState());

  Future<void> getPost(String postId) async {
    emit(state.copyWith(isLoading: true));

    try {
      final post = await _postRepo.getPost(postId);
      if (post is ResultFailed) {
        emit(ViewPostError(post.error!.message, state));
        return;
      }
      emit(state.copyWith(post: post.data, isLoading: false));
    } catch (e) {
      emit(ViewPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final result = await _postRepo.addPostClap(postId);
      if (result is ResultFailed) {
        emit(ViewPostError(result.error.message, state));
        return;
      }
      emit(state.copyWith(
        post: state.post!.copyWith(claps: state.post!.claps + 1),
      ));
    } catch (e) {
      emit(ViewPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> likeComment(String postId, String commentId) async {
    try {
      final result = await _postRepo.addPostCommentClap(postId, commentId);
      if (result is ResultFailed) {
        emit(ViewPostError(result.error.message, state));
        return;
      }
      emit(state.copyWith(
        post: state.post!.copyWith(
            comments: state.post!.comments.map((e) {
          if (e.id == commentId) {
            return e.copyWith(claps: e.claps + 1);
          }
          return e;
        }).toList()),
      ));
    } catch (e) {
      emit(ViewPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> selectPollOption(String postId, int optionId) async {
    try {
      final result = await _postRepo.selectPollOption(postId, optionId);
      if (result is ResultFailed) {
        emit(ViewPostError(result.error!.message, state));
        return;
      }
      emit(state.copyWith(
        post: (state.post as PollPost).copyWith(votes: result.data),
      ));
    } catch (e) {
      emit(ViewPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> addComment(String postId, String comment) async {
    try {
      final result = await _postRepo.addPostComment(postId, comment);
      if (result is ResultFailed) {
        emit(ViewPostError(result.error!.message, state));
        return;
      }
      final comments = state.post!.comments;
      comments.insert(0, result.data!);
      emit(state.copyWith(
        post: state.post!.copyWith(comments: comments),
      ));
    } catch (e) {
      emit(ViewPostError('An error occurred. Please try again.', state));
    }
  }
}
