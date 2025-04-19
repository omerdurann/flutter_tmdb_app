import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';

class MovieCardWidget extends StatelessWidget {
  final String posterUrl;
  final String title;
  final double rating;
  final int reviewCount;
  final String duration;
  final String genres;

  const MovieCardWidget({
    super.key,
    // Placeholders for now
    this.posterUrl =
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg", // Shang-Chi Poster
    this.title = "Shang-Chi and the Legend of the Ten Rings",
    this.rating = 4.0,
    this.reviewCount = 982,
    this.duration = "2 hour 5 minutes",
    this.genres = "Action, Sci-Fi",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, // Make card background transparent
      elevation: 0, // No shadow for the card itself
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(context.dynamicWidth(0.03)),
            child: Image.network(
              posterUrl,
              fit: BoxFit.cover,
              height: context.dynamicHeight(0.25),
              width: double.infinity,
              // Optional: Add loading/error builders
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: context.dynamicHeight(0.25),
                  color: AppColors.darkBackgroundColor.withOpacity(0.8),
                  child: Center(
                      child: SizedBox(
                          width: context.dynamicWidth(0.1),
                          height: context.dynamicWidth(0.1),
                          child: const CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: AppColors.primaryColor))),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                  height: context.dynamicHeight(0.25),
                  color: AppColors.darkBackgroundColor.withOpacity(0.8),
                  child: Icon(Icons.error,
                      color: AppColors.whiteColor,
                      size: context.dynamicHeight(0.05))),
            ),
          ),
          SizedBox(height: context.dynamicHeight(0.01)),

          // Movie Title
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.01)),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: context.dynamicHeight(0.018),
              ),
            ),
          ),
          SizedBox(height: context.dynamicHeight(0.005)),

          // Rating
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.01)),
            child: Row(
              children: [
                Icon(Icons.star,
                    color: AppColors.primaryColor,
                    size: context.dynamicHeight(0.02)),
                SizedBox(width: context.dynamicWidth(0.01)),
                Text(
                  '$rating ($reviewCount reviews)',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.grayColor,
                    fontSize: context.dynamicHeight(0.015),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.dynamicHeight(0.005)),

          // Duration
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.01)),
            child: Row(
              children: [
                Icon(Icons.access_time,
                    color: AppColors.grayColor,
                    size: context.dynamicHeight(0.02)),
                SizedBox(width: context.dynamicWidth(0.01)),
                Text(
                  duration,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.grayColor,
                    fontSize: context.dynamicHeight(0.015),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.dynamicHeight(0.005)),

          // Genres
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.01)),
            child: Row(
              children: [
                Icon(Icons.theaters,
                    color: AppColors.grayColor,
                    size: context.dynamicHeight(0.02)),
                SizedBox(width: context.dynamicWidth(0.01)),
                Expanded(
                  child: Text(
                    genres,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.grayColor,
                      fontSize: context.dynamicHeight(0.015),
                    ),
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
