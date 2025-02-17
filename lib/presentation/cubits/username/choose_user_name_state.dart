part of 'choose_user_name_cubit.dart';

class ChooseUserNameState extends Equatable {
  final bool isLoading;

  const ChooseUserNameState({
    this.isLoading = false,
  });

  @override
  List<Object> get props => [isLoading];

  ChooseUserNameState copyWith({
    bool? isLoading,
  }) {
    return ChooseUserNameState(isLoading: isLoading ?? this.isLoading);
  }
}

class ChooseUserNameError extends ChooseUserNameState {
  final String message;

  const ChooseUserNameError(this.message);

  @override
  List<Object> get props => [Random()];
}

class ChooseUserNameSuccess extends ChooseUserNameState {
  const ChooseUserNameSuccess();

  @override
  List<Object> get props => [];
}
