import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/config/widgets/custom_appbar.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/widgets/movie_grid_view.dart';

class Favorites extends ConsumerWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Gerçek favori listesini Hive'dan veya provider'dan al
    final List<dynamic> favoriteMovies =
        List.generate(4, (index) => index); // Örnek 4 favori

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
