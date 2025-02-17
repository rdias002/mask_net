import 'exception_wrapper.dart';

sealed class Result<T> {
  const Result();

  T? get data => this is ResultSuccess ? this.data : null;
  ExceptionWrapper? get error => this is ResultFailed ? this.error : null;
}

final class ResultSuccess<T> extends Result<T> {
  @override
  final T data;
  const ResultSuccess(this.data) : super();
}

final class ResultFailed<T> extends Result<T> {
  @override
  final ExceptionWrapper error;
  const ResultFailed(this.error) : super();
}
