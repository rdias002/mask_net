import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/result.dart';
import '../../../data/model/companies.dart';
import '../../../data/model/post.dart';
import '../../../data/post_repo.dart';

part 'company_post_state.dart';

class CompanyPostCubit extends Cubit<CompanyPostState> {
  final PostRepo _postRepo;

  CompanyPostCubit(this._postRepo) : super(const CompanyPostState());

  void setCompanyId(String companyId) {
    emit(state.copyWith(
      companyId: companyId,
      company: companies.firstWhere((e) => e.id == companyId),
    ));
  }

  Future<void> getPosts() async {
    emit(state.copyWith(isLoading: true));

    try {
      final posts = await _postRepo.getPosts(companyId: state.companyId);
      if (posts is ResultFailed) {
        emit(CompanyPostError(posts.error!.message, state));
        return;
      }
      emit(state.copyWith(posts: posts.data, isLoading: false));
    } catch (e) {
      emit(CompanyPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final result = await _postRepo.addPostClap(postId);
      if (result is ResultFailed) {
        emit(CompanyPostError(result.error.message, state));
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
      emit(CompanyPostError('An error occurred. Please try again.', state));
    }
  }

  Future<void> selectPollOption(String postId, int optionId) async {
    try {
      final result = await _postRepo.selectPollOption(postId, optionId);
      if (result is ResultFailed) {
        emit(CompanyPostError(result.error!.message, state));
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
      emit(CompanyPostError('An error occurred. Please try again.', state));
    }
  }
}
