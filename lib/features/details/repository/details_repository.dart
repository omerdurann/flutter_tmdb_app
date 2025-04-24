import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/movie_detail_model.dart';

import '../../../config/utility/enums/api_endpoints.dart';
import '../../../config/utility/enums/api_methods.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/service/remote/api_service.dart';

final detailsRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return DetailsRepository(apiService);
});

class DetailsRepository {
  final ApiService _apiService;

  DetailsRepository(this._apiService);

  Future<DataState<MovieDetailModel>> getMovieDetails(int movieId) async {
    try {
      final String baseUrlWithPath = ApiEndPoints.movieDetail.getEndpoint;
      final String finalUrl = '$baseUrlWithPath/$movieId';

      final result = await _apiService.request(
        method: ApiMethods.get.method,
        url: finalUrl,
      );

      if (result.data != null) {
        final movie = MovieDetailModel.fromMap(result.data!);
        return DataSuccess(data: movie);
      } else {
        return DataError(message: result.message);
      }
    } on DioException catch (e) {
      return DataError(message: e.message);
    } catch (e) {
      return DataError(message: e.toString());
    }
  }
}
