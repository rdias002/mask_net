part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final bool isLoading;

  const SignUpState({
    this.isLoading = false,
  });

  @override
  List<Object> get props => [isLoading];

  SignUpState copyWith({
    bool? isLoading,
  }) {
    return SignUpState(isLoading: isLoading ?? this.isLoading);
  }
}

class SignUpError extends SignUpState {
  final String message;

  const SignUpError(this.message);

  @override
  List<Object> get props => [Random()];
}

class SignUpSuccess extends SignUpState {
  const SignUpSuccess();

  @override
  List<Object> get props => [];
}
