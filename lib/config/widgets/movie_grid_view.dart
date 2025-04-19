import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/widgets/movie_card_widget.dart';

class MovieGridView extends ConsumerWidget {
  final List<dynamic> movies; // Model geldiğinde List<Movie> yap

  const MovieGridView({super.key, required this.movies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        // TODO: Model geldiğinde buradaki movie verisini kullan
        // final movie = movies[index];
        return const MovieCardWidget(
            // movie: movie, // Modeli pass et
            );
      },
    );
  }
}
