import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mask_net/config/result.dart';
import 'package:mask_net/data/auth_repo.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepo _authRepo;

  SignUpCubit(this._authRepo) : super(const SignUpState());

  Future<void> signUp(
      String email, String password, String confirmPassword) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const SignUpError('Email and password cannot be empty.'));
      return;
    }

    if (password != confirmPassword) {
      emit(const SignUpError('Passwords do not match.'));
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      emit(const SignUpError('Please enter a valid email'));
      return;
    }

    if (password.length < 6) {
      emit(const SignUpError('Password must be at least 6 characters long.'));
      return;
    }
    try {
      emit(state.copyWith(isLoading: true));
      final result = await _authRepo.createAccount(email, password);
      if (result is ResultFailed) {
        emit(SignUpError(result.error.message));
        return;
      }
      emit(const SignUpSuccess());
    } catch (e) {
      emit(const SignUpError('Something went wrong. Please try again.'));
    }
  }
}
