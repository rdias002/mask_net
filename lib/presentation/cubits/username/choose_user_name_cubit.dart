import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mask_net/config/result.dart';
import 'package:mask_net/data/auth_repo.dart';

part 'choose_user_name_state.dart';

class ChooseUserNameCubit extends Cubit<ChooseUserNameState> {
  final AuthRepo _authRepo;

  ChooseUserNameCubit(this._authRepo) : super(const ChooseUserNameState());

  Future<void> saveUserName(String username) async {
    try {
      final alphanumeric = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
      if (!alphanumeric.hasMatch(username)) {
        emit(const ChooseUserNameError(
            'Username must be alphanumeric and start with a letter.'));
        return;
      }
      emit(state.copyWith(isLoading: true));
      final result = await _authRepo.saveUserName(username);
      if (result is ResultFailed) {
        emit(ChooseUserNameError(result.error.message));
      } else {
        emit(const ChooseUserNameSuccess());
      }
    } catch (e) {
      emit(
          const ChooseUserNameError('Something went wrong. Please try again.'));
    }
  }
}
