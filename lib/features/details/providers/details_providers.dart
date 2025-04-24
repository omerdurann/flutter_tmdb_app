import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/movie_detail_model.dart';
import 'package:flutter_tmdb_app/core/resources/data_state.dart';
import 'package:flutter_tmdb_app/features/details/repository/details_repository.dart';

final movieDetailProvider = StateNotifierProvider.family<MovieDetailsNotifier,
    AsyncValue<MovieDetailModel>, int>((ref, movieId) {
  final repository = ref.watch(detailsRepositoryProvider);
  return MovieDetailsNotifier(repository, movieId);
});

class MovieDetailsNotifier extends StateNotifier<AsyncValue<MovieDetailModel>> {
  final DetailsRepository _repository;
  final int _movieId;

  MovieDetailsNotifier(this._repository, this._movieId)
      : super(const AsyncValue.loading()) {
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    try {
      final dataState = await _repository.getMovieDetails(_movieId);

      if (dataState is DataSuccess && dataState.data != null) {
        state = AsyncValue.data(dataState.data!);
      } else if (dataState is DataError) {
        state = AsyncValue.error(
            dataState.message ?? 'Film detayları yüklenemedi',
            StackTrace.current);
      } else {
        state =
            AsyncValue.error('Bilinmeyen bir hata oluştu', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
