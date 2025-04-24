// ignore: depend_on_referenced_packages
// ignore_for_file: unused_local_variable

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/core/extensions/movie_model_extensions.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/genres_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/production_company_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/production_countries_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/spoken_languages_model.dart';
import 'package:flutter_tmdb_app/features/favorite/providers/favorites_provider.dart';
import 'package:flutter_tmdb_app/features/details/providers/details_providers.dart';
import 'package:flutter_tmdb_app/core/models/movie_model.dart';
import 'package:flutter_tmdb_app/config/utility/utils/utils.dart';
import 'package:flutter_tmdb_app/config/models/notification_model.dart';
import 'package:toastification/toastification.dart';

import '../widgets/header_section.dart';
import '../widgets/details_body_section.dart';
import '../../../config/widgets/custom_loading_anim.dart';

class DetailsScreen extends ConsumerWidget {
  final int? movieId;

  const DetailsScreen({super.key, this.movieId});

  Widget _buildImagePlaceholder(BuildContext context, double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundColor.withOpacity(0.8),
      ),
      child: Icon(Icons.image_not_supported,
          color: AppColors.grayColor, size: context.dynamicHeight(0.05)),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context, double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundColor.withOpacity(0.8),
      ),
      child: Center(
          child: LoadingAnimationWidget(
        width: context.dynamicWidth(0.1),
        height: context.dynamicWidth(0.1),
      )),
    );
  }

  String _formatCurrency(int? amount) {
    if (amount == null || amount == 0) return 'Bilgi Yok';
    final format = NumberFormat.compactSimpleCurrency(locale: 'en_US');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (movieId == null) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackgroundColor,
        body: Center(
          child:
              Text('Film ID bulunamadı.', style: TextStyle(color: Colors.red)),
        ),
      );
    }

    final movieDetailAsyncValue = ref.watch(movieDetailProvider(movieId!));

    final favoritesState = ref.watch(favoritesProvider);
    final isFavorited = favoritesState.maybeWhen(
      data: (list) => list.any((fav) => fav.id == movieId),
      orElse: () => false,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.whiteColor,
              size: context.dynamicHeight(0.022),
            ),
          ),
        ),
        actions: [
          movieDetailAsyncValue.maybeWhen(
            data: (movieDetail) => IconButton(
              icon: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  size: context.dynamicHeight(0.025),
                ),
              ),
              onPressed: () {
                final movieForFavorite = MovieModel(
                  id: movieDetail.id,
                  title: movieDetail.title,
                  posterPath: movieDetail.posterPath,
                  releaseDate: movieDetail.releaseDate,
                  voteAverage: movieDetail.voteAverage ?? 0.0,
                  originalLanguage: movieDetail.originalLanguage,
                  overview: movieDetail.overview,
                  voteCount: movieDetail.voteCount,
                  adult: movieDetail.adult,
                  backdropPath: movieDetail.backdropPath,
                );

                ref
                    .read(favoritesProvider.notifier)
                    .toggleFavorite(movieForFavorite);

                final subtitle = isFavorited
                    ? '"${movieForFavorite.title ?? 'Film'}" favorilerden çıkarıldı'
                    : '"${movieForFavorite.title ?? 'Film'}" favorilere eklendi';

                Utils.showFlushbar(
                  context,
                  FlushbarNotificationModel(
                    type: ToastificationType.success,
                    title: "Başarılı",
                    subtitle: subtitle,
                  ),
                );
              },
              tooltip: isFavorited ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      backgroundColor: AppColors.darkBackgroundColor,
      body: movieDetailAsyncValue.when(
        data: (movieDetail) {
          final movieModel = MovieModel(
            id: movieDetail.id,
            title: movieDetail.title ?? '',
            voteAverage: movieDetail.voteAverage ?? 0.0,
            backdropPath: movieDetail.backdropPath,
          );
          final String fullBackdropUrl = movieModel.fullBackdropPath;

          final List<GenresModel> genres = movieDetail.genres ?? [];
          final List<ProductionCountriesModel> productionCountries =
              movieDetail.productionCountries ?? [];
          final List<ProductionCompanyModel> productionCompanies =
              movieDetail.productionCompanies ?? [];
          final List<SpokenLanguagesModel> spokenLanguages =
              movieDetail.spokenLanguages ?? [];

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(
                  movieDetail: movieDetail,
                  buildImagePlaceholder: _buildImagePlaceholder,
                  buildLoadingPlaceholder: _buildLoadingPlaceholder,
                ),
                DetailsBodySection(
                  movieDetail: movieDetail,
                  genres: genres,
                  productionCountries: productionCountries,
                  productionCompanies: productionCompanies,
                  spokenLanguages: spokenLanguages,
                  formatCurrency: _formatCurrency,
                  buildInfoRow: _buildInfoRow,
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Film detayları yüklenemedi.\nHata: ${error.toString()}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        loading: () {
          return Center(
            child: LoadingAnimationWidget(
              width: context.dynamicWidth(0.2),
              height: context.dynamicWidth(0.2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    if (value.isEmpty || value == '-' || value == 'Bilgi Yok') {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dynamicHeight(0.005)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.dynamicWidth(0.3),
            child: Text(
              label,
              style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.whiteColor, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
