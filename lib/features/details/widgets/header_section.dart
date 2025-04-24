import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/core/extensions/movie_model_extensions.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/movie_detail_model.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';

class HeaderSection extends StatelessWidget {
  final MovieDetailModel movieDetail;
  final Widget Function(BuildContext, double) buildImagePlaceholder;
  final Widget Function(BuildContext, double) buildLoadingPlaceholder;

  const HeaderSection({
    super.key, // Add super.key
    required this.movieDetail,
    required this.buildImagePlaceholder,
    required this.buildLoadingPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    final movieModel = MovieModel(
      id: movieDetail.id,
      title: movieDetail.title ?? '',
      voteAverage: movieDetail.voteAverage ?? 0.0,
      backdropPath: movieDetail.backdropPath,
      releaseDate: movieDetail.releaseDate,
      posterPath: movieDetail.posterPath,
      originalLanguage: movieDetail.originalLanguage,
      overview: movieDetail.overview,
      voteCount: movieDetail.voteCount,
      adult: movieDetail.adult,
    );
    final String fullBackdropUrl = movieModel.fullBackdropPath;

    return SizedBox(
      height: context.dynamicHeight(0.45),
      child: Stack(
        children: [
          Positioned.fill(
            child: (movieDetail.backdropPath != null &&
                    movieDetail.backdropPath!.isNotEmpty)
                ? Image.network(
                    fullBackdropUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        buildImagePlaceholder(
                            context, context.dynamicHeight(0.45)),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return buildLoadingPlaceholder(
                          context, context.dynamicHeight(0.45));
                    },
                  )
                : buildImagePlaceholder(context, context.dynamicHeight(0.45)),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.darkBackgroundColor.withOpacity(0.5),
                    AppColors.darkBackgroundColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: context.dynamicHeight(0.02),
            left: context.dynamicWidth(0.04),
            right: context.dynamicWidth(0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieDetail.title ?? 'Başlık Yok',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.5))
                      ]),
                ),
                if (movieDetail.tagline != null &&
                    movieDetail.tagline!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: context.dynamicHeight(0.005)),
                    child: Text(
                      movieDetail.tagline!,
                      style: context.textTheme.titleSmall?.copyWith(
                          color: AppColors.whiteColor.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                                blurRadius: 2.0,
                                color: Colors.black.withOpacity(0.5))
                          ]),
                    ),
                  ),
                SizedBox(height: context.dynamicHeight(0.01)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.dynamicWidth(0.02),
                      vertical: context.dynamicHeight(0.005)),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (movieDetail.runtime != null &&
                          movieDetail.runtime! > 0)
                        Icon(Icons.timer_outlined,
                            color: AppColors.whiteColor,
                            size: context.dynamicHeight(0.018)),
                      SizedBox(width: context.dynamicWidth(0.01)),
                      if (movieDetail.runtime != null &&
                          movieDetail.runtime! > 0)
                        Text(
                          "${movieDetail.runtime! ~/ 60}h ${movieDetail.runtime! % 60}m",
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500),
                        ),
                      if (movieDetail.runtime != null &&
                          movieDetail.runtime! > 0 &&
                          movieDetail.releaseDate != null &&
                          movieDetail.releaseDate!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.dynamicWidth(0.02)),
                          child: const Text("•",
                              style: TextStyle(color: AppColors.whiteColor)),
                        ),
                      if (movieDetail.releaseDate != null &&
                          movieDetail.releaseDate!.isNotEmpty)
                        Icon(Icons.calendar_today_outlined,
                            color: AppColors.whiteColor,
                            size: context.dynamicHeight(0.018)),
                      SizedBox(width: context.dynamicWidth(0.01)),
                      if (movieDetail.releaseDate != null &&
                          movieDetail.releaseDate!.isNotEmpty)
                        Text(
                          MovieModel(
                            // Create MovieModel here for formatted date
                            id: movieDetail.id,
                            releaseDate: movieDetail.releaseDate,
                            title:
                                '', // Provide default or actual title if needed elsewhere
                            voteAverage:
                                0, // Provide default or actual rating if needed
                            // Add other required fields if MovieModel constructor needs them
                            posterPath: movieDetail.posterPath,
                            backdropPath: movieDetail.backdropPath,
                            originalLanguage: movieDetail.originalLanguage,
                            overview: movieDetail.overview,
                            voteCount: movieDetail.voteCount,
                            adult: movieDetail.adult,
                          ).formattedReleaseDate,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
