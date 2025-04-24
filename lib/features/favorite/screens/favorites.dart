import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/config/widgets/custom_appbar.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/widgets/movie_grid_view.dart';
import 'package:flutter_tmdb_app/features/favorite/providers/favorites_provider.dart';
import '../../../config/widgets/custom_loading_anim.dart';

class Favorites extends ConsumerWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.dynamicHeight(0.07),
        ),
        child: CustomAppBar(
          color: AppColors.darkBackgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryColor,
              size: context.dynamicHeight(0.02),
            ),
          ),
          titleColor: AppColors.whiteColor,
          title: "Favoriler",
        ),
      ),
      backgroundColor: AppColors.darkBackgroundColor,
      body: favoritesState.when(
        data: (favoriteMovies) {
          if (favoriteMovies.isEmpty) {
            return const Center(
              child: Text(
                'Henüz favori filminiz yok.',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            );
          }
          return MovieGridView(movies: favoriteMovies);
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Favoriler yüklenirken hata oluştu: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        },
        loading: () {
          return Center(
            child: LoadingAnimationWidget(
              width: context.dynamicWidth(0.2),
              height: context.dynamicWidth(0.2),
            ),
          );
        },
      ),
    );
  }
}
