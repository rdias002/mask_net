import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/result.dart';
import '../../../data/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _authRepo;
  LoginCubit(this._authRepo) : super(const LoginState());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginError('Email and password cannot be empty'));
      return;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      emit(const LoginError('Please enter a valid email'));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      // Simulate a network call
      final result = await _authRepo.login(email, password);
      if (result is ResultFailed) {
        emit(LoginError(result.error.message));
        return;
      }

      // Assume login is successful
      emit(const LoginSuccess());
    } catch (e) {
      emit(const LoginError('An error occurred. Please try again.'));
    }
  }
}
