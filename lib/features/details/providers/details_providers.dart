import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/movie_detail_model.dart';
import 'package:flutter_tmdb_app/core/resources/data_state.dart';
import 'package:flutter_tmdb_app/features/details/repository/details_repository.dart';

// MovieDetailNotifier için Provider Family
// int tipinde movieId alır ve AsyncValue<MovieDetailModel> döndürür
final movieDetailProvider = StateNotifierProvider.family<MovieDetailsNotifier,
    AsyncValue<MovieDetailModel>, int>((ref, movieId) {
  // Repository provider'ını oku
  final repository = ref.watch(detailsRepositoryProvider);
  // Notifier'ı movieId ve repository ile başlat
  return MovieDetailsNotifier(repository, movieId);
});

class MovieDetailsNotifier extends StateNotifier<AsyncValue<MovieDetailModel>> {
  final DetailsRepository _repository;
  final int _movieId;

  MovieDetailsNotifier(this._repository, this._movieId)
      // Başlangıçta loading state'i ile başla
      : super(const AsyncValue.loading()) {
    // Notifier oluşturulur oluşturulmaz detayları çek
    _fetchMovieDetails();
  }

  // Film detaylarını getiren özel metod
  Future<void> _fetchMovieDetails() async {
    // State'i tekrar loading yapmaya gerek yok, zaten başta öyle
    // state = const AsyncValue.loading();
    try {
      // Repository'den veriyi al
      final dataState = await _repository.getMovieDetails(_movieId);

      // Gelen veriyi kontrol et
      if (dataState is DataSuccess && dataState.data != null) {
        // Başarılıysa state'i data olarak güncelle
        state = AsyncValue.data(dataState.data!);
      } else if (dataState is DataError) {
        // Hata varsa state'i error olarak güncelle
        state = AsyncValue.error(
            dataState.message ?? 'Film detayları yüklenemedi',
            StackTrace.current);
      } else {
        // Beklenmedik durum
        state =
            AsyncValue.error('Bilinmeyen bir hata oluştu', StackTrace.current);
      }
    } catch (e, st) {
      // Genel hata yakalama
      state = AsyncValue.error(e, st);
    }
  }
}
