import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/config/widgets/custom_appbar.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/widgets/movie_grid_view.dart';

import '../../../core/models/movie_model.dart';

class Favorites extends ConsumerWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Gerçek favori listesini Hive'dan veya provider'dan al
    // Örnek MovieModel listesi (Modelin doğru alan adlarıyla)
    final List<MovieModel> favoriteMovies = [
      // Örnek 1
      MovieModel(
        // posterPath null olabilir, ?? ile varsayılan atayalım
        posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
        title: "Fight Club (Favorite)",
        voteAverage: 8.433, // Bu required
        voteCount: 26000,
        // Diğer alanlar null bırakılabilir veya varsayılan atanabilir
        id: 550, // Örnek ID
        overview: "A ticking-time-bomb insomniac...",
        releaseDate: "1999-10-15",
      ),
      // Örnek 2
      MovieModel(
        posterPath: "/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        title: "Shang-Chi (Favorite)",
        voteAverage: 7.5, // Bu required
        voteCount: 10000,
        id: 566525, // Örnek ID
        overview: "Shang-Chi must confront the past...",
        releaseDate: "2021-09-01",
      ),
    ];

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
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Text(
                'Henüz favori filminiz yok.',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            )
          : MovieGridView(movies: favoriteMovies),
    );
  }
}
