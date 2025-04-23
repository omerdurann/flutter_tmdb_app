import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/widgets/movie_card_widget.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';

class MovieGridView extends ConsumerWidget {
  final List<MovieModel> movies;

  const MovieGridView({super.key, required this.movies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.04),
        vertical: context.dynamicHeight(0.02),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (context.width / 2) / (context.dynamicHeight(0.45)),
        crossAxisSpacing: context.dynamicWidth(0.04),
        mainAxisSpacing: context.dynamicHeight(0.02),
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        return MovieCardWidget(
          posterUrl:
              movie.posterPath != null ? imageBaseUrl + movie.posterPath! : "",
          title: movie.title ?? "Başlık Yok",
          rating: movie.voteAverage,
          reviewCount: movie.voteCount ?? 0,
        );
      },
    );
  }
}
