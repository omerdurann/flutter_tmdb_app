import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/widgets/movie_card_widget.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';

class MovieGridView extends ConsumerWidget {
  final List<MovieModel> movies;
  final ScrollController? scrollController;

  const MovieGridView({
    super.key,
    required this.movies,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.04),
        vertical: context.dynamicHeight(0.02),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (context.width / 2) / (context.dynamicHeight(0.46)),
        crossAxisSpacing: context.dynamicWidth(0.04),
        mainAxisSpacing: context.dynamicHeight(0.02),
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        return MovieCardWidget(movie: movie);
      },
    );
  }
}
