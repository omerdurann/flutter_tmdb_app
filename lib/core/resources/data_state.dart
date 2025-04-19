abstract class DataState<T> {
  final T? data;
  final String? message;

  DataState({this.data, this.message});
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess({super.data});
}

class DataError<T> extends DataState<T> {
  DataError({super.message});
}
