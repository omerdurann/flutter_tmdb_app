import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';

// Convert to StatefulWidget
class MovieCardWidget extends StatefulWidget {
  final String posterUrl;
  final String title;
  final double rating;
  final int reviewCount;
  final String duration;
  final String genres;

  const MovieCardWidget({
    super.key,
    this.posterUrl =
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
    this.title = "Shang-Chi and the Legend of the Ten Rings",
    this.rating = 4.0,
    this.reviewCount = 982,
    this.duration = "2 hour 5 minutes",
    this.genres = "Action, Sci-Fi",
  });

  @override
  State<MovieCardWidget> createState() => _MovieCardWidgetState();
}

class _MovieCardWidgetState extends State<MovieCardWidget> {
  // Add state variable for favorite status
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.dynamicWidth(0.03)),
                child: Image.network(
                  widget.posterUrl, // Use widget.posterUrl
                  fit: BoxFit.cover,
                  height: context.dynamicHeight(0.25),
                  width: double.infinity,
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
              Positioned(
                top: context.dynamicHeight(0.01),
                right: context.dynamicWidth(0.02),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      // Change icon based on state
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      // Change color based on state
                      color: _isFavorited
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                      size: context.dynamicHeight(0.025),
                    ),
                    onPressed: () {
                      // Toggle state on press
                      setState(() {
                        _isFavorited = !_isFavorited;
                      });
                      print("Favori butonu tıklandı! Durum: $_isFavorited");
                    },
                    tooltip:
                        _isFavorited ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(context.dynamicWidth(0.015)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.dynamicHeight(0.01)),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.01)),
            child: Text(
              widget.title, // Use widget.title
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
                  '${widget.rating} (${widget.reviewCount} reviews)', // Use widget.
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.grayColor,
                    fontSize: context.dynamicHeight(0.015),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.dynamicHeight(0.005)),
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
                  widget.duration, // Use widget.
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.grayColor,
                    fontSize: context.dynamicHeight(0.015),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.dynamicHeight(0.005)),
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
                    widget.genres, // Use widget.
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
