part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  final bool isLoading;

  const ForgotPasswordState({
    this.isLoading = false,
  });

  @override
  List<Object> get props => [isLoading];

  ForgotPasswordState copyWith({
    bool? isLoading,
  }) {
    return ForgotPasswordState(isLoading: isLoading ?? this.isLoading);
  }
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;

  const ForgotPasswordError(this.message);

  @override
  List<Object> get props => [Random()];
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess();

  @override
  List<Object> get props => [];
}
