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
    fetchNextPage(); // İlk yükleme
  }

  Future<void> fetchNextPage({bool isRefresh = false}) async {
    // Çoklu eş zamanlı istekleri veya daha fazla veri olmadığında istek yapmayı engelle
    if (_isLoadingMore || (!_hasMoreData && !isRefresh)) return;

    _isLoadingMore = true;

    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      state = const AsyncValue
          .loading(); // Yenileme sırasında yükleme göstergesini göster
    } else if (state is! AsyncLoading && _currentPage == 1) {
      // Yüklemeyi sadece ilk istekte göster (sonraki sayfalarda değil)
      state = const AsyncValue.loading();
    }

    try {
      final result = await _repository.getTrendingMovies(page: _currentPage);

      if (result is DataSuccess<List<MovieModel>>) {
        final newMovies = result.data ?? [];
        if (newMovies.isEmpty) {
          _hasMoreData = false;
          // İlk sayfa/yenileme boş dönerse, durumu boş veri olarak güncelle
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
        // Hatayı sadece ilk sayfa/yenileme yüklemesi başarısız olursa göster
        if (_currentPage == 1 || isRefresh) {
          state = AsyncValue.error(
              result.message ?? 'Trend filmler yüklenemedi',
              StackTrace.current);
        }
        debugPrint(
            "Error fetching trending movies page $_currentPage: ${result.message}");
      } else {
        // Beklenmedik DataState türlerini işle
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
  String _currentQuery = "";

  SearchMoviesNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> searchMovies(String query) async {
    final trimmedQuery = query.trim();
    // Daha önce bir hata olmadıkça aynı sorgu için tekrar arama yapmaktan kaçın
    if (trimmedQuery == _currentQuery && state is! AsyncError) return;

    _currentQuery = trimmedQuery;
    if (_currentQuery.isEmpty) {
      // Sorgu boşsa sonuçları temizle ve durumu sıfırla
      state = const AsyncValue.data([]);
      _resetPagination();
      return;
    }

    // Yeni bir arama başlat: sayfalama sıfırla ve yükleme göster
    _resetPagination();
    state = const AsyncValue.loading();
    await fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    // Sorgu boşsa, zaten yükleniyorsa veya daha fazla veri yoksa çık
    if (_currentQuery.isEmpty || _isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;

    // Not: Yükleme göstergesi yalnızca ilk arama yüklemesinde gösterilir (searchMovies içinde halledilir),
    // sonraki sayfa yüklemelerinde daha akıcı bir sayfalama deneyimi sağlamak için gösterilmez.

    try {
      final result = await _repository.searchMovies(
          query: _currentQuery, page: _currentPage);

      if (result is DataSuccess<List<MovieModel>>) {
        final newMovies = result.data ?? [];
        if (newMovies.isEmpty) {
          _hasMoreData = false;
          // İlk sayfa boşsa, durumu boş veri olarak ayarla
          if (_currentPage == 1) {
            state = const AsyncValue.data([]);
          }
          // Sonraki sayfalar boşsa, duruma dokunma, sadece getirmeyi durdur
        } else {
          _hasMoreData = true;
          final currentMovies = state.value ?? <MovieModel>[];
          state = AsyncValue.data([...currentMovies, ...newMovies]);
          _currentPage++;
        }
      } else if (result is DataError) {
        _hasMoreData = false;
        // Hatayı sadece ilk sayfa yüklemesi başarısız olursa göster
        if (_currentPage == 1) {
          state = AsyncValue.error(
              result.message ?? 'Arama sonuçları yüklenemedi',
              StackTrace.current);
        }
        debugPrint(
            "Error fetching search results page $_currentPage for query '$_currentQuery': ${result.message}");
      } else {
        // Beklenmedik DataState türlerini işle
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

  // Yeni bir arama için sayfalama durumunu sıfırlayan yardımcı metod
  void _resetPagination() {
    _currentPage = 1;
    _hasMoreData = true;
    _isLoadingMore = false;
  }

  // Mevcut arama sorgusunu ve sonuçlarını temizler
  void clearSearch() {
    _currentQuery = "";
    _resetPagination();
    state = const AsyncValue.data([]);
  }
}
