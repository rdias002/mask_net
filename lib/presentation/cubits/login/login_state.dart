part of 'login_cubit.dart';

class LoginState extends Equatable {
  final bool isLoading;

  const LoginState({
    this.isLoading = false,
  });

  @override
  List<Object> get props => [isLoading];

  LoginState copyWith({
    bool? isLoading,
  }) {
    return LoginState(isLoading: isLoading ?? this.isLoading);
  }
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [Random()];
}

class LoginSuccess extends LoginState {
  const LoginSuccess();

  @override
  List<Object> get props => [];
}
