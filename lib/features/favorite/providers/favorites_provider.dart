import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';
import 'package:flutter_tmdb_app/core/service/local/hive_database_service.dart';

// FavoritesNotifier için Provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<MovieModel>>>(
        (ref) {
  return FavoritesNotifier(HiveDatabaseService.instance)..init();
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<MovieModel>>> {
  final HiveDatabaseService _hiveService;
  final String _boxName = 'favorite';

  FavoritesNotifier(this._hiveService) : super(const AsyncValue.loading());

  Future<void> init() async {
    try {
      final favoriteMaps = await _hiveService.getAllData<Map>(_boxName);
      final favoriteMovies = favoriteMaps.map((map) {
        final safeMap = Map<String, dynamic>.from(map);
        return MovieModel.fromMap(safeMap);
      }).toList();
      state = AsyncValue.data(favoriteMovies);
    } catch (e, st) {
      debugPrint("Favoriler yüklenirken hata: $e");
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(MovieModel movie) async {
    final movieIdString = movie.id.toString();
    final previousState = state;

    if (previousState is! AsyncData<List<MovieModel>>) return;

    final currentFavorites = previousState.value;
    final isCurrentlyFavorite =
        currentFavorites.any((fav) => fav.id == movie.id);

    try {
      if (isCurrentlyFavorite) {
        await _hiveService.deleteData<Map>(_boxName, movieIdString);
        state = AsyncValue.data(
            currentFavorites.where((fav) => fav.id != movie.id).toList());
      } else {
        final movieMap = movie.toMap();
        await _hiveService.putData<Map>(_boxName, movieIdString, movieMap);
        state = AsyncValue.data([...currentFavorites, movie]);
      }
    } catch (e, st) {
      debugPrint("Favori durumu değiştirilirken hata: $e");
      state = AsyncValue.error(e, st);
    }
  }

  bool isFavorite(int movieId) {
    if (state is AsyncData<List<MovieModel>>) {
      return state.value!.any((fav) => fav.id == movieId);
    }
    return false;
  }

  int get favoriteCount {
    if (state is AsyncData<List<MovieModel>>) {
      return state.value!.length;
    }
    return 0;
  }
}
