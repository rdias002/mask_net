// ignore_for_file: public_member_api_docs, sort_constructors_first

class ExceptionWrapper {
  final String message;
  final Exception? error;
  ExceptionWrapper({
    required this.message,
    this.error,
  });

  ExceptionWrapper copyWith({
    Exception? error,
    String? message,
  }) {
    return ExceptionWrapper(
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}

class ResultException implements Exception {
  final String message;
  ResultException(this.message);
}

class UserNotLoggedInException implements Exception {
  UserNotLoggedInException();
}
