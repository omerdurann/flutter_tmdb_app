import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';
import 'package:flutter_tmdb_app/core/extensions/movie_model_extensions.dart';
import 'package:flutter_tmdb_app/features/details/screens/details.dart';
import 'package:flutter_tmdb_app/features/favorite/providers/favorites_provider.dart';
import 'package:flutter_tmdb_app/config/utility/utils/utils.dart';
import 'package:flutter_tmdb_app/config/models/notification_model.dart';
import 'package:toastification/toastification.dart';

class MovieCardWidget extends ConsumerWidget {
  final MovieModel movie;

  const MovieCardWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);

    // Mevcut filmin favori listesinde olup olmadığını kontrol et.
    final isFavorited = favoritesState.maybeWhen(
      data: (favoriteList) => favoriteList.any((fav) => fav.id == movie.id),
      orElse: () => false,
    );

    return InkWell(
      onTap: () {
        if (movie.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(movieId: movie.id!),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(context.dynamicWidth(0.03)),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(context.dynamicWidth(0.03)),
                  child: Image.network(
                    movie.fullPosterPath,
                    fit: BoxFit.cover,
                    height: context.dynamicHeight(0.25),
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                        height: context.dynamicHeight(0.25),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.darkBackgroundColor.withOpacity(0.8),
                          borderRadius:
                              BorderRadius.circular(context.dynamicWidth(0.03)),
                        ),
                        child: Icon(Icons.image_not_supported,
                            color: AppColors.grayColor,
                            size: context.dynamicHeight(0.05))),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: context.dynamicHeight(0.25),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.darkBackgroundColor.withOpacity(0.8),
                          borderRadius:
                              BorderRadius.circular(context.dynamicWidth(0.03)),
                        ),
                        child: Center(
                            child: SizedBox(
                                width: context.dynamicWidth(0.1),
                                height: context.dynamicWidth(0.1),
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: AppColors.primaryColor))),
                      );
                    },
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
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited
                            ? AppColors.primaryColor
                            : AppColors.whiteColor,
                        size: context.dynamicHeight(0.025),
                      ),
                      onPressed: () {
                        // Butona basılmadan önceki favori durumunu al.
                        final wasFavorited =
                            ref.read(favoritesProvider).maybeWhen(
                                  data: (list) =>
                                      list.any((fav) => fav.id == movie.id),
                                  orElse: () => false,
                                );

                        // Favori durumunu değiştir (ekle/çıkar).
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(movie);

                        final subtitle = wasFavorited
                            ? '"${movie.title ?? 'Film'}" favorilerden çıkarıldı'
                            : '"${movie.title ?? 'Film'}" favorilere eklendi';

                        Utils.showFlushbar(
                          context,
                          FlushbarNotificationModel(
                            type: ToastificationType.success,
                            title: "Başarılı",
                            subtitle: subtitle,
                          ),
                        );
                      },
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
                movie.title ?? "Başlık Yok",
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
                    '${movie.voteAverage.toStringAsFixed(1)} (${movie.voteCount ?? 0} reviews)',
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
                  Icon(Icons.calendar_today,
                      color: AppColors.grayColor,
                      size: context.dynamicHeight(0.02)),
                  SizedBox(width: context.dynamicWidth(0.01)),
                  Text(
                    movie.formattedReleaseDate,
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
                  Icon(Icons.language,
                      color: AppColors.grayColor,
                      size: context.dynamicHeight(0.02)),
                  SizedBox(width: context.dynamicWidth(0.01)),
                  Expanded(
                    child: Text(
                      movie.originalLanguage?.toUpperCase() ?? "-",
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
      ),
    );
  }
}
