import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/features/home/widgets/movie_card_widget.dart';

class MovieGridView extends ConsumerWidget {
  const MovieGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder for movie list - replace with actual data later
    final movieList = List.generate(6, (index) => index); // Example: 6 movies

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.04),
        vertical: context.dynamicHeight(0.02),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns as in the reference image
        childAspectRatio: (context.width / 2) /
            (context.dynamicHeight(0.45)), // Adjust aspect ratio dynamically
        crossAxisSpacing: context.dynamicWidth(0.04), // Already dynamic
        mainAxisSpacing: context.dynamicHeight(0.02), // Already dynamic
      ),
      itemCount: movieList.length, // Number of movies
      itemBuilder: (context, index) {
        // Pass actual movie data here when available
        return const MovieCardWidget(
            // Example placeholder overrides if needed for different cards
            // title: "Movie Title $index",
            // posterUrl: "...
            );
      },
    );
  }
}
