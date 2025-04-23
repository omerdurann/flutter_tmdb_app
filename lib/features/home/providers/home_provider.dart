import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';
import 'package:flutter/foundation.dart'; // log için

import '../../../core/resources/data_state.dart';
import '../repository/home_repository.dart';

// --- Trend Filmler için Provider ---
final trendingMoviesProvider =
    StateNotifierProvider<TrendingMoviesNotifier, AsyncValue<List<MovieModel>>>(
        (ref) {
  return TrendingMoviesNotifier(ref.watch(homeRepositoryProvider));
});

class TrendingMoviesNotifier
    extends StateNotifier<AsyncValue<List<MovieModel>>> {
  final HomeRepository _repository;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  TrendingMoviesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchNextPage(); // İlk sayfayı yükle
  }

  Future<void> fetchNextPage({bool isRefresh = false}) async {
    if (_isLoadingMore || (!_hasMoreData && !isRefresh)) return;

    _isLoadingMore = true;

    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      state = const AsyncValue.loading();
    } else if (state is! AsyncLoading && _currentPage == 1) {
      // İlk yüklemede loading göstermek için (refresh değilse)
      state = const AsyncValue.loading();
    }

    try {
      final result = await _repository.getTrendingMovies(page: _currentPage);

      if (result is DataSuccess<List<MovieModel>>) {
        final newMovies = result.data ?? [];
        if (newMovies.isEmpty) {
          _hasMoreData = false;
          if (_currentPage == 1 || isRefresh) {
            state = const AsyncValue.data([]);
          }
        } else {
          _hasMoreData = true;
          final currentMovies = (isRefresh || state.value == null)
              ? <MovieModel>[]
              : state.value!;
          state = AsyncValue.data([...currentMovies, ...newMovies]);
          _currentPage++;
        }
      } else if (result is DataError) {
        _hasMoreData = false;
        if (_currentPage == 1 || isRefresh) {
          state = AsyncValue.error(
              result.message ?? 'Trend filmler yüklenemedi',
              StackTrace.current);
        }
        debugPrint(
            "Error fetching trending movies page $_currentPage: ${result.message}");
      } else {
        _hasMoreData = false;
        if (_currentPage == 1 || isRefresh) {
          state = AsyncValue.error(
              'Bilinmeyen bir durum oluştu', StackTrace.current);
        }
        debugPrint(
            "Unknown state received while fetching trending movies page $_currentPage");
      }
    } catch (e, st) {
      _hasMoreData = false;
      if (_currentPage == 1 || isRefresh) {
        state = AsyncValue.error(e, st);
      }
      debugPrint("Error in TrendingMoviesNotifier.fetchNextPage: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMoreData() async {
    await fetchNextPage();
  }

  Future<void> refresh() async {
    await fetchNextPage(isRefresh: true);
  }
}

// --- Arama Sonuçları için Provider ---
final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, AsyncValue<List<MovieModel>>>(
        (ref) {
  return SearchMoviesNotifier(ref.watch(homeRepositoryProvider));
});

class SearchMoviesNotifier extends StateNotifier<AsyncValue<List<MovieModel>>> {
  final HomeRepository _repository;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMoreData = true;
  String _currentQuery = ""; // Mevcut arama sorgusu
  // Debounce için Timer ekleyebiliriz (isteğe bağlı)

  // Başlangıçta boş bir liste veya belirli bir başlangıç durumu ile başla
  SearchMoviesNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> searchMovies(String query) async {
    // Sorgu değişmediyse veya boşsa bir şey yapma (isteğe bağlı olarak boş sorguda temizlenebilir)
    if (query.trim() == _currentQuery && state is! AsyncError) return;

    _currentQuery = query.trim();
    if (_currentQuery.isEmpty) {
      // Boş sorguda listeyi temizle ve çık
      state = const AsyncValue.data([]);
      _currentPage = 1;
      _hasMoreData = true; // Yeni arama için sıfırla
      _isLoadingMore = false;
      return;
    }

    // Yeni arama, durumu sıfırla ve ilk sayfayı yükle
    _currentPage = 1;
    _hasMoreData = true;
    _isLoadingMore = false; // Önceki yüklemeyi iptal et (varsa)
    state = const AsyncValue.loading(); // Arama başlarken loading göster
    await fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    // Eğer sorgu boşsa veya zaten yükleniyorsa veya daha fazla veri yoksa çık
    if (_currentQuery.isEmpty || _isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;

    // Not: Arama sırasında sayfa > 1 iken loading göstermiyoruz,
    // yeni veriler geldiğinde liste güncellenir.

    try {
      final result = await _repository.searchMovies(
          query: _currentQuery, page: _currentPage);

      if (result is DataSuccess<List<MovieModel>>) {
        final newMovies = result.data ?? [];
        if (newMovies.isEmpty) {
          _hasMoreData = false;
          // İlk sayfa boş geldiyse state'i boş data yap
          if (_currentPage == 1) {
            state = const AsyncValue.data([]);
          }
          // Sonraki sayfalar boş geldiyse state değişmez, sadece _hasMoreData false olur
        } else {
          _hasMoreData = true;
          final currentMovies = state.value ?? <MovieModel>[];
          // İlk sayfa yüklemesi (loading durumundan geliyorsa) veya sonraki sayfa eklemesi
          state = AsyncValue.data([...currentMovies, ...newMovies]);
          _currentPage++;
        }
      } else if (result is DataError) {
        _hasMoreData = false;
        // Sadece ilk sayfa yüklenirken hata gösterilir
        if (_currentPage == 1) {
          state = AsyncValue.error(
              result.message ?? 'Arama sonuçları yüklenemedi',
              StackTrace.current);
        }
        debugPrint(
            "Error fetching search results page $_currentPage for query '$_currentQuery': ${result.message}");
      } else {
        _hasMoreData = false;
        if (_currentPage == 1) {
          state = AsyncValue.error(
              'Bilinmeyen bir durum oluştu', StackTrace.current);
        }
        debugPrint(
            "Unknown state received while fetching search page $_currentPage for query '$_currentQuery'");
      }
    } catch (e, st) {
      _hasMoreData = false;
      if (_currentPage == 1) {
        state = AsyncValue.error(e, st);
      }
      debugPrint("Error in SearchMoviesNotifier.fetchNextPage: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMoreResults() async {
    await fetchNextPage();
  }

  // İsteğe bağlı: Aramayı manuel olarak temizlemek için
  void clearSearch() {
    _currentQuery = "";
    _currentPage = 1;
    _hasMoreData = true;
    _isLoadingMore = false;
    state = const AsyncValue.data([]); // Durumu başlangıç haline getir
  }
}
