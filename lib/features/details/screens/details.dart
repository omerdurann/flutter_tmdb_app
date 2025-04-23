import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/genres_model.dart'; // GenresModel import
import 'package:flutter_tmdb_app/core/models/movieDetail/production_company_model.dart'; // CompanyModel import
import 'package:flutter_tmdb_app/core/models/movieDetail/production_countries_model.dart'; // CountryModel import
import 'package:flutter_tmdb_app/core/models/movieDetail/spoken_languages_model.dart';
import 'package:flutter_tmdb_app/features/favorite/providers/favorites_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tmdb_app/features/details/providers/details_providers.dart'; // Details Provider import
import 'package:flutter_tmdb_app/core/models/movieDetail/movie_detail_model.dart'; // Model import
import 'package:flutter_tmdb_app/core/models/movie_model.dart'; // MovieModel import (favori için)
import 'package:flutter_tmdb_app/core/extensions/movie_model_extensions.dart'; // MovieModelExtension eklendi
import 'package:flutter_tmdb_app/core/constants/api_constants.dart'; // ApiConstants eklendi

class DetailsScreen extends ConsumerWidget {
  // ConsumerWidget yaptık
  final int? movieId;

  const DetailsScreen({super.key, this.movieId});

  // Placeholder image builder (MovieCard'dakine benzer)
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
      child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor)),
    );
  }

  String _formatCurrency(int? amount) {
    if (amount == null || amount == 0) return 'Bilgi Yok';
    final format = NumberFormat.compactSimpleCurrency(locale: 'en_US');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gelen movieId null ise hata göster veya geri dön
    if (movieId == null) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackgroundColor,
        body: Center(
          child:
              Text('Film ID bulunamadı.', style: TextStyle(color: Colors.red)),
        ),
      );
    }

    // İlgili filmin detay state'ini izle
    final movieDetailAsyncValue = ref.watch(movieDetailProvider(movieId!));

    // Favori state'ini izle
    final favoritesState = ref.watch(favoritesProvider);
    final isFavorited = favoritesState.maybeWhen(
      data: (list) => list.any((fav) => fav.id == movieId),
      orElse: () => false,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Provider durumuna göre AppBar ve Body oluştur
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
          // Favori Butonu (Sadece veri yüklendiğinde gösterilebilir)
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
                // MovieDetailModel'i MovieModel'e dönüştür (veya notifier'ı güncelle)
                // En basit yol, gerekli alanlarla yeni bir MovieModel oluşturmak
                final movieForFavorite = MovieModel(
                  id: movieDetail.id,
                  title: movieDetail.title,
                  posterPath: movieDetail.posterPath,
                  releaseDate: movieDetail.releaseDate,
                  voteAverage:
                      movieDetail.voteAverage ?? 0.0, // voteAverage null olamaz
                  // Diğer gerekli alanlar (MovieModel constructor'ına göre)
                  originalLanguage: movieDetail.originalLanguage,
                  overview: movieDetail.overview,
                  voteCount: movieDetail.voteCount,
                  // ... (MovieModel'in diğer zorunlu olmayan alanları null olabilir)
                  adult: movieDetail.adult,
                  backdropPath: movieDetail.backdropPath,
                );
                ref
                    .read(favoritesProvider.notifier)
                    .toggleFavorite(movieForFavorite);
              },
              tooltip: isFavorited ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
            ),
            orElse: () => const SizedBox
                .shrink(), // Yüklenirken veya hata durumunda buton gösterme
          ),
        ],
      ),
      backgroundColor: AppColors.darkBackgroundColor,
      // Provider durumuna göre Body'yi göster
      body: movieDetailAsyncValue.when(
        data: (movieDetail) {
          // Veri başarıyla geldi, UI'ı gerçek veriyle doldur
          // MovieModel extension'larını kullanarak backdrop URL'si oluştur
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
                // --- Backdrop Image ve Üst Bilgiler ---
                SizedBox(
                  height: context.dynamicHeight(0.45),
                  child: Stack(
                    children: [
                      // Backdrop Image
                      Positioned.fill(
                        child: (movieDetail.backdropPath != null &&
                                movieDetail.backdropPath!.isNotEmpty)
                            ? Image.network(
                                fullBackdropUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImagePlaceholder(
                                        context, context.dynamicHeight(0.45)),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return _buildLoadingPlaceholder(
                                      context, context.dynamicHeight(0.45));
                                },
                              )
                            : _buildImagePlaceholder(
                                context, context.dynamicHeight(0.45)),
                      ),
                      // Gradient Overlay (isteğe bağlı, yazıları okunur kılar)
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
                              stops: const [0.4, 0.7, 1.0], // Geçiş noktaları
                            ),
                          ),
                        ),
                      ),
                      // Başlık, Süre, Tarih (Resmin üzerine bindirildi)
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
                                    // Hafif gölge
                                    Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black.withOpacity(0.5))
                                  ]),
                            ),
                            if (movieDetail.tagline != null &&
                                movieDetail.tagline!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(
                                    top: context.dynamicHeight(0.005)),
                                child: Text(
                                  movieDetail.tagline!,
                                  style: context.textTheme.titleSmall?.copyWith(
                                      color:
                                          AppColors.whiteColor.withOpacity(0.8),
                                      fontStyle: FontStyle.italic,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 2.0,
                                            color:
                                                Colors.black.withOpacity(0.5))
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
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  if (movieDetail.runtime != null &&
                                      movieDetail.runtime! > 0 &&
                                      movieDetail.releaseDate != null &&
                                      movieDetail.releaseDate!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.dynamicWidth(0.02)),
                                      child: const Text("•",
                                          style: TextStyle(
                                              color: AppColors.whiteColor)),
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
                                      // Extension kullanarak tarihi formatla
                                      MovieModel(
                                        id: movieDetail.id,
                                        releaseDate: movieDetail.releaseDate,
                                        title: '',
                                        voteAverage: 0,
                                      ).formattedReleaseDate,
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
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
                ),

                // --- Detay İçerikleri ---
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.dynamicWidth(0.04),
                      vertical: context.dynamicHeight(0.02)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Puan (İsteğe bağlı)
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: AppColors.primaryColor,
                              size: context.dynamicHeight(0.025)),
                          SizedBox(width: context.dynamicWidth(0.015)),
                          Text(
                            (movieDetail.voteAverage ?? 0.0)
                                .toStringAsFixed(1), // Tek ondalık
                            style: context.textTheme.titleMedium?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " / 10",
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: AppColors.whiteColor),
                          ),
                          SizedBox(width: context.dynamicWidth(0.03)),
                          if (movieDetail.voteCount != null &&
                              movieDetail.voteCount! > 0)
                            Text(
                              "(${NumberFormat.compact().format(movieDetail.voteCount)} oy)",
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: AppColors.whiteColor),
                            ),
                        ],
                      ),
                      SizedBox(height: context.dynamicHeight(0.025)),

                      // Türler (Genres)
                      Text("Türler",
                          style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600)),
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
                                  backgroundColor:
                                      Colors.black.withOpacity(0.4),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.dynamicWidth(0.025),
                                      vertical: context.dynamicHeight(0.008)),
                                  side: BorderSide.none,
                                ))
                            .toList(),
                      ),
                      SizedBox(height: context.dynamicHeight(0.025)),

                      // Açıklama (Overview)
                      Text("Özet",
                          style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: context.dynamicHeight(0.01)),
                      Text(
                        movieDetail.overview ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          height: 1.5, // Satır aralığı
                        ),
                      ),
                      SizedBox(height: context.dynamicHeight(0.025)),

                      _buildInfoRow(
                          context, "Durum:", movieDetail.status ?? "-"),
                      _buildInfoRow(
                          context,
                          "Konuşulan Diller:",
                          spokenLanguages
                              .map((l) => l.englishName ?? l.name ?? '')
                              .where((n) => n.isNotEmpty)
                              .join(', ')),
                      _buildInfoRow(context, "Bütçe:",
                          _formatCurrency(movieDetail.budget)),
                      _buildInfoRow(context, "Hasılat:",
                          _formatCurrency(movieDetail.revenue)),
                      SizedBox(height: context.dynamicHeight(0.025)),

                      // TODO: Yönetmen ve Oyuncular (API'den veri gelince eklenecek)

                      if (productionCompanies.isNotEmpty) ...[
                        // Şirketler varsa göster
                        Text("Yapımcı Şirketler",
                            style: context.textTheme.titleLarge?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: context.dynamicHeight(0.015)),
                        SizedBox(
                          height: context.dynamicHeight(
                              0.08), // Yatay liste için sabit yükseklik
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

                              // Logo veya isim göstermek için widget
                              Widget logoOrNameWidget;
                              if (fullLogoUrl.isNotEmpty) {
                                logoOrNameWidget = Image.network(
                                  fullLogoUrl,
                                  fit: BoxFit.contain,
                                  // Hata durumunda veya yüklenirken sadece isim göster
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Text(
                                      company.name ?? '',
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.black),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Yüklenirken de placeholder veya isim gösterilebilir
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null)
                                      return child; // Yüklendiyse resmi göster
                                    // Yüklenirken küçük bir indicator veya sadece isim gösterilebilir
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
                                // Logo URL'si yoksa sadece ismi göster
                                logoOrNameWidget = Center(
                                  child: Text(
                                    company.name ?? '',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black),
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
                                    clipBehavior: Clip
                                        .antiAlias, // İçeriğin taşmasını engellemek için
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.whiteColor.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        logoOrNameWidget, // Oluşturulan widget'ı kullan
                                  ),
                                  // SizedBox(height: context.dynamicHeight(0.005)), // İsim alta yazdırılmayacaksa bu kaldırılabilir
                                ],
                              ); // Column sonu
                            }, // itemBuilder sonu
                          ),
                        ),
                        SizedBox(height: context.dynamicHeight(0.025)),
                      ],

                      if (productionCountries.isNotEmpty) ...[
                        // Ülkeler varsa göster
                        Text("Yapımcı Ülkeler",
                            style: context.textTheme.titleLarge?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600)),
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
                                    backgroundColor:
                                        Colors.black.withOpacity(0.4),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: context.dynamicWidth(0.025),
                                        vertical: context.dynamicHeight(0.008)),
                                    side: BorderSide.none,
                                  ))
                              .toList(),
                        ),
                        SizedBox(
                            height:
                                context.dynamicHeight(0.04)), // En alta boşluk
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          // Hata durumunda gösterilecek widget
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
          // Yükleniyor durumunda gösterilecek widget (Tüm ekranı kaplar)
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        },
      ),
    );
  }

  // Küçük bilgi satırları oluşturmak için helper widget
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    // Değer boş veya "-" ise satırı hiç gösterme
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
