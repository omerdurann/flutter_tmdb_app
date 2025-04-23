import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';

import '../../../config/utility/enums/api_endpoints.dart';
import '../../../config/utility/enums/api_methods.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/service/remote/api_service.dart';

final homeRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HomeRepository(apiService);
});

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<DataState<List<MovieModel>>> getTrendingMovies(
      {required int page}) async {
    try {
      final result = await _apiService.request(
        method: ApiMethods.get.method,
        url: ApiEndPoints.trendingMoviesDay.getEndpoint,
        query: {'page': page},
      );

      if (result.data != null) {
        final List<dynamic> resultsData = result.data!['results'] as List;
        final List<MovieModel> movies = resultsData
            .map((movieJson) =>
                MovieModel.fromMap(movieJson as Map<String, dynamic>))
            .toList();
        return DataSuccess(data: movies);
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
