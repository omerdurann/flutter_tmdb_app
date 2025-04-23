import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';
import 'package:flutter/foundation.dart'; // log için

import '../../../core/resources/data_state.dart';
import '../repository/home_repository.dart';

final homeProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<List<MovieModel>>>((ref) {
  return HomeNotifier(ref.watch(homeRepositoryProvider));
});

class HomeNotifier extends StateNotifier<AsyncValue<List<MovieModel>>> {
  final HomeRepository _repository;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMoreData = true; // Başlangıçta true varsayalım

  HomeNotifier(this._repository) : super(const AsyncValue.loading()) {
    _fetchTrendingMovies(); // İlk veriyi yükle
  }

  Future<void> _fetchTrendingMovies({bool isRefresh = false}) async {
    // Zaten yükleniyorsa veya daha fazla veri yoksa (ve refresh değilse) çık
    if (_isLoadingMore || (!_hasMoreData && !isRefresh)) return;

    _isLoadingMore = true;

    // Durumu güncelle: Refresh ise veya ilk sayfa yükleniyorsa Loading göster
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData =
          true; // Refresh yapıldığında tekrar veri olabileceğini varsay
      state = const AsyncValue.loading();
    } else if (_currentPage == 1) {
      // İlk sayfa yüklenirken de loading gösterilebilir (isteğe bağlı)
      // state = const AsyncValue.loading();
    }

    try {
      // Repository'den veriyi çek
      final result = await _repository.getTrendingMovies(page: _currentPage);

      // Başarı durumu kontrolü
      if (result is DataSuccess<List<MovieModel>>) {
        final List<MovieModel> newMovies =
            result.data ?? []; // Gelen yeni filmler

        // Gelen liste boşsa, daha fazla veri yoktur
        if (newMovies.isEmpty) {
          _hasMoreData = false;
          // Eğer ilk sayfa ve liste boşsa, state'i boş liste olarak ayarla
          if (_currentPage == 1 || isRefresh) {
            state = const AsyncValue.data([]);
          }
          // Eğer sonraki sayfalar boş geldiyse, mevcut state korunur,
          // sadece _hasMoreData false olur.
        } else {
          // Yeni filmler geldiyse, daha fazla veri olabilir
          _hasMoreData = true;
          // Mevcut film listesini al
          final List<MovieModel> currentMovies = state.value ?? [];
          // Listeyi güncelle (refresh ise yenisi, değilse ekle)
          final List<MovieModel> updatedMovies =
              isRefresh ? newMovies : [...currentMovies, ...newMovies];
          // State'i güncelle
          state = AsyncValue.data(updatedMovies);
          // Sonraki sayfaya geç
          _currentPage++;
        }
      } else if (result is DataError) {
        // Hata durumu
        _hasMoreData =
            false; // Hata durumunda daha fazla veri olmadığını varsayalım
        if (_currentPage == 1 || isRefresh) {
          // İlk sayfada veya refresh sırasında hata olursa state'i güncelle
          state = AsyncValue.error(
              result.message ?? 'Veri yüklenirken hata oluştu',
              StackTrace.current);
        }
        // Sonraki sayfalarda hata olursa, kullanıcıya göstermeden loglayabiliriz
        // veya mevcut state'i koruyabiliriz.
        debugPrint("Error fetching page $_currentPage: ${result.message}");
      } else {
        // Beklenmedik durum (DataState değilse?)
        _hasMoreData = false;
        if (_currentPage == 1 || isRefresh) {
          state = AsyncValue.error(
              'Bilinmeyen bir durum oluştu', StackTrace.current);
        }
      }
    } catch (e, st) {
      // Genel Hata Yakalama (örn: Repository içindeki beklenmedik hatalar)
      _hasMoreData = false;
      if (_currentPage == 1 || isRefresh) {
        state = AsyncValue.error(e, st);
      }
      debugPrint("Error in _fetchTrendingMovies: $e");
    } finally {
      // Yükleme durumunu bitir
      _isLoadingMore = false;
    }
  }

  // Daha fazla veri yükleme fonksiyonu
  Future<void> loadMoreData() async {
    await _fetchTrendingMovies();
  }

  // Listeyi yenileme fonksiyonu
  Future<void> refreshList() async {
    await _fetchTrendingMovies(isRefresh: true);
  }
}
