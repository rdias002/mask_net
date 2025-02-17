import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/result.dart';
import '../../../data/model/companies.dart';
import '../../../data/model/post.dart';
import '../../../data/post_repo.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepo _postRepo;
  final String companyId;

  CreatePostCubit(this._postRepo, [this.companyId = channelGeneral])
      : super(const CreatePostState(postType: textPostType));

  Future<void> createPost(
    String title,
    String body,
    String image,
    List<String> polls,
  ) async {
    if (title.isEmpty) {
      emit(const CreatePostError('Title cannot be empty'));
      return;
    } else if (postTypes.contains(state.postType) == false) {
      emit(const CreatePostError('Please select a post type'));
      return;
    } else if (state.postType == textPostType && body.isEmpty) {
      emit(const CreatePostError('Body cannot be empty'));
      return;
    } else if (state.postType == imagePostType && image.isEmpty) {
      emit(const CreatePostError('Please select an image'));
      return;
    } else if (state.postType == pollPostType && polls.length < 2) {
      emit(const CreatePostError('Please add at least two poll option'));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final result = await _postRepo.createPost(
        companyId,
        state.postType,
        title,
        body,
        File(image),
        polls,
      );
      if (result is ResultFailed) {
        emit(CreatePostError(result.error!.message));
        return;
      }

      emit(CreatePostSuccess(result.data!));
    } catch (e) {
      emit(const CreatePostError('An error occurred. Please try again.'));
    }
  }

  void setPostType(String type) {
    emit(state.copyWith(postType: type, imageUrl: '', polls: []));
  }

  void setImage(String imageUrl) {
    emit(state.copyWith(imageUrl: imageUrl));
  }

  void setPolls(List<String> polls) {
    emit(state.copyWith(polls: polls));
  }
}
