import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../config/result.dart';
import '../../../data/auth_repo.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepo _authRepo;
  ForgotPasswordCubit(this._authRepo) : super(const ForgotPasswordState());

  Future<void> sendResetPasswordLink(String email) async {
    if (email.isEmpty) {
      emit(const ForgotPasswordError('Email cannot be empty'));
      return;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      emit(const ForgotPasswordError('Please enter a valid email'));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      // Simulate a network call
      final result = await _authRepo.sendResetPasswordLink(email);
      if (result is ResultFailed) {
        emit(ForgotPasswordError(result.error.message));
        return;
      }

      emit(const ForgotPasswordSuccess());
    } catch (e) {
      emit(const ForgotPasswordError('An error occurred. Please try again.'));
    }
  }
}
