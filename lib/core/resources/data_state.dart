abstract class DataState<T> {
  final T? data;
  final String? message;

  const DataState({this.data, this.message});
}

class DataSuccess<T> extends DataState<T> {
  final int? page;
  final int? totalPages;
  final int? totalResults;

  const DataSuccess({super.data, this.page, this.totalPages, this.totalResults})
      : super(message: null);
}

class DataError<T> extends DataState<T> {
  final int? statusCode;
  final bool? success;

  const DataError({super.message, this.statusCode, this.success})
      : super(data: null);
}
