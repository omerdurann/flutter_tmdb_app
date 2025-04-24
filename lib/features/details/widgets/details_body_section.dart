// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/core/constants/api_constants.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/genres_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/movie_detail_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/production_company_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/production_countries_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/spoken_languages_model.dart';

class DetailsBodySection extends StatelessWidget {
  final MovieDetailModel movieDetail;
  final List<GenresModel> genres;
  final List<ProductionCountriesModel> productionCountries;
  final List<ProductionCompanyModel> productionCompanies;
  final List<SpokenLanguagesModel> spokenLanguages;
  final String Function(int?) formatCurrency;
  final Widget Function(BuildContext, String, String) buildInfoRow;

  const DetailsBodySection({
    super.key, 
    required this.movieDetail,
    required this.genres,
    required this.productionCountries,
    required this.productionCompanies,
    required this.spokenLanguages,
    required this.formatCurrency,
    required this.buildInfoRow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.04),
          vertical: context.dynamicHeight(0.02)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star,
                  color: AppColors.primaryColor,
                  size: context.dynamicHeight(0.025)),
              SizedBox(width: context.dynamicWidth(0.015)),
              Text(
                (movieDetail.voteAverage ?? 0.0).toStringAsFixed(1),
                style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.whiteColor, fontWeight: FontWeight.bold),
              ),
              Text(
                " / 10",
                style: context.textTheme.bodySmall
                    ?.copyWith(color: AppColors.whiteColor),
              ),
              SizedBox(width: context.dynamicWidth(0.03)),
              if (movieDetail.voteCount != null && movieDetail.voteCount! > 0)
                Text(
                  "(${NumberFormat.compact().format(movieDetail.voteCount)} oy)",
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: AppColors.whiteColor),
                ),
            ],
          ),
          SizedBox(height: context.dynamicHeight(0.025)),
          Text("Türler",
              style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
          SizedBox(height: context.dynamicHeight(0.01)),
          Wrap(
            spacing: context.dynamicWidth(0.02),
            runSpacing: context.dynamicHeight(0.005),
            children: genres
                .map((genre) => Chip(
                      label: Text(
                        genre.name ?? 'Bilinmiyor',
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      backgroundColor: Colors.black.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                          horizontal: context.dynamicWidth(0.025),
                          vertical: context.dynamicHeight(0.008)),
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
          SizedBox(height: context.dynamicHeight(0.025)),
          Text("Özet",
              style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
          SizedBox(height: context.dynamicHeight(0.01)),
          Text(
            movieDetail.overview ?? '',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              height: 1.5,
            ),
          ),
          SizedBox(height: context.dynamicHeight(0.025)),
          buildInfoRow(context, "Durum:", movieDetail.status ?? "-"),
          buildInfoRow(
              context,
              "Konuşulan Diller:",
              spokenLanguages
                  .map((l) => l.englishName ?? l.name ?? '')
                  .where((n) => n.isNotEmpty)
                  .join(', ')),
          buildInfoRow(context, "Bütçe:", formatCurrency(movieDetail.budget)),
          buildInfoRow(
              context, "Hasılat:", formatCurrency(movieDetail.revenue)),
          SizedBox(height: context.dynamicHeight(0.025)),
          if (productionCompanies.isNotEmpty) ...[
            Text("Yapımcı Şirketler",
                style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
            SizedBox(height: context.dynamicHeight(0.015)),
            SizedBox(
              height: context.dynamicHeight(0.08),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: productionCompanies.length,
                separatorBuilder: (context, index) =>
                    SizedBox(width: context.dynamicWidth(0.03)),
                itemBuilder: (context, index) {
                  final company = productionCompanies[index];
                  final fullLogoUrl = company.logoPath != null &&
                          company.logoPath!.isNotEmpty
                      ? "${ApiConstants.imageBaseUrl}w200${company.logoPath!}"
                      : "";

                  Widget logoOrNameWidget;
                  if (fullLogoUrl.isNotEmpty) {
                    logoOrNameWidget = Image.network(
                      fullLogoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          company.name ?? '',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppColors.primaryColor)),
                        );
                      },
                    );
                  } else {
                    logoOrNameWidget = Center(
                      child: Text(
                        company.name ?? '',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.black),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: context.dynamicHeight(0.05),
                        width: context.dynamicWidth(0.2),
                        padding: const EdgeInsets.all(4.0),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: logoOrNameWidget,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: context.dynamicHeight(0.025)),
          ],
          if (productionCountries.isNotEmpty) ...[
            Text("Yapımcı Ülkeler",
                style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
            SizedBox(height: context.dynamicHeight(0.01)),
            Wrap(
              spacing: context.dynamicWidth(0.02),
              children: productionCountries
                  .map((country) => Chip(
                        label: Text(
                          country.name ?? 'Bilinmiyor',
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: Colors.black.withOpacity(0.4),
                        padding: EdgeInsets.symmetric(
                            horizontal: context.dynamicWidth(0.025),
                            vertical: context.dynamicHeight(0.008)),
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
            SizedBox(height: context.dynamicHeight(0.04)),
          ],
        ],
      ),
    );
  }
}
