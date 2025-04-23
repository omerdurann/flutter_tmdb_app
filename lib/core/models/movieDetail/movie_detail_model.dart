// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_tmdb_app/core/models/movieDetail/genres_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/production_company_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/production_countries_model.dart';
import 'package:flutter_tmdb_app/core/models/movieDetail/spoken_languages_model.dart';

class MovieDetailModel {
  final bool? adult;
  final String? backdropPath;
  final String? bellogsToCollection;
  final int? budget;
  final List<GenresModel>? genres;
  final String? homepage;
  final int? id;
  final String? imdbId;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<ProductionCompanyModel>? productionCompanies;
  final List<ProductionCountriesModel>? productionCountries;
  final String? releaseDate;
  final int? revenue;
  final int? runtime;
  final List<SpokenLanguagesModel>? spokenLanguages;
  final String? status;
  final String? tagline;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  MovieDetailModel({
    this.adult,
    this.backdropPath,
    this.bellogsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  MovieDetailModel copyWith({
    bool? adult,
    String? backdropPath,
    String? bellogsToCollection,
    int? budget,
    List<GenresModel>? genres,
    String? homepage,
    int? id,
    String? imdbId,
    String? originalLanguage,
    String? originalTitle,
    String? overview,
    double? popularity,
    String? posterPath,
    List<ProductionCompanyModel>? productionCompanies,
    List<ProductionCountriesModel>? productionCountries,
    String? releaseDate,
    int? revenue,
    int? runtime,
    List<SpokenLanguagesModel>? spokenLanguages,
    String? status,
    String? tagline,
    String? title,
    bool? video,
    double? voteAverage,
    int? voteCount,
  }) {
    return MovieDetailModel(
      adult: adult ?? this.adult,
      backdropPath: backdropPath ?? this.backdropPath,
      bellogsToCollection: bellogsToCollection ?? this.bellogsToCollection,
      budget: budget ?? this.budget,
      genres: genres ?? this.genres,
      homepage: homepage ?? this.homepage,
      id: id ?? this.id,
      imdbId: imdbId ?? this.imdbId,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      posterPath: posterPath ?? this.posterPath,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      releaseDate: releaseDate ?? this.releaseDate,
      revenue: revenue ?? this.revenue,
      runtime: runtime ?? this.runtime,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      status: status ?? this.status,
      tagline: tagline ?? this.tagline,
      title: title ?? this.title,
      video: video ?? this.video,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adult': adult,
      'backdrop_path': backdropPath,
      'belongs_to_collection': bellogsToCollection,
      'budget': budget,
      'genres': genres?.map((x) => x.toMap()).toList(),
      'homepage': homepage,
      'id': id,
      'imdb_id': imdbId,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'production_companies':
          productionCompanies?.map((x) => x.toMap()).toList(),
      'production_countries':
          productionCountries?.map((x) => x.toMap()).toList(),
      'release_date': releaseDate,
      'revenue': revenue,
      'runtime': runtime,
      'spoken_languages': spokenLanguages?.map((x) => x.toMap()).toList(),
      'status': status,
      'tagline': tagline,
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }

  factory MovieDetailModel.fromMap(Map<String, dynamic> map) {
    return MovieDetailModel(
      adult: map['adult'] as bool?,
      backdropPath: map['backdrop_path'] as String?,
      // belongs_to_collection Map veya null olabilir. Map ise içinden 'name' alalım.
      bellogsToCollection: map['belongs_to_collection'] is Map<String, dynamic>
          ? (map['belongs_to_collection'] as Map<String, dynamic>)['name']
              as String?
          : null, // Map değilse veya null ise null ata
      budget: map['budget'] as int?,
      // Listeleri doğrudan map ile parse et, null kontrolleriyle
      genres: map['genres'] is List
          ? (map['genres'] as List<dynamic>)
              .map((item) => GenresModel.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      homepage: map['homepage'] as String?,
      id: map['id'] as int?,
      imdbId: map['imdb_id'] as String?,
      originalLanguage: map['original_language'] as String?,
      originalTitle: map['original_title'] as String?,
      overview: map['overview'] as String?,
      popularity: (map['popularity'] as num?)?.toDouble(),
      posterPath: map['poster_path'] as String?,
      productionCompanies: map['production_companies'] is List
          ? (map['production_companies'] as List<dynamic>)
              .map((item) =>
                  ProductionCompanyModel.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      productionCountries: map['production_countries'] is List
          ? (map['production_countries'] as List<dynamic>)
              .map((item) => ProductionCountriesModel.fromMap(
                  item as Map<String, dynamic>))
              .toList()
          : null,
      releaseDate: map['release_date'] as String?,
      revenue: map['revenue'] as int?,
      runtime: map['runtime'] as int?,
      spokenLanguages: map['spoken_languages'] is List
          ? (map['spoken_languages'] as List<dynamic>)
              .map((item) =>
                  SpokenLanguagesModel.fromMap(item as Map<String, dynamic>))
              .toList()
          : null,
      status: map['status'] as String?,
      tagline: map['tagline'] as String?,
      title: map['title'] as String?,
      video: map['video'] as bool?,
      voteAverage: (map['vote_average'] as num?)?.toDouble(),
      voteCount: map['vote_count'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieDetailModel.fromJson(String source) =>
      MovieDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MovieDetailModel(adult: $adult, backdrop_path: $backdropPath, belongs_to_collection: $bellogsToCollection, budget: $budget, genres: $genres, homepage: $homepage, id: $id, imdb_id: $imdbId, original_language: $originalLanguage, original_title: $originalTitle, overview: $overview, popularity: $popularity, poster_path: $posterPath, production_companies: $productionCompanies, production_countries: $productionCountries, release_date: $releaseDate, revenue: $revenue, runtime: $runtime, spoken_languages: $spokenLanguages, status: $status, tagline: $tagline, title: $title, video: $video, vote_average: $voteAverage, vote_count: $voteCount)';
  }

  @override
  bool operator ==(covariant MovieDetailModel other) {
    if (identical(this, other)) return true;

    return other.adult == adult &&
        other.backdropPath == backdropPath &&
        other.bellogsToCollection == bellogsToCollection &&
        other.budget == budget &&
        listEquals(other.genres, genres) &&
        other.homepage == homepage &&
        other.id == id &&
        other.imdbId == imdbId &&
        other.originalLanguage == originalLanguage &&
        other.originalTitle == originalTitle &&
        other.overview == overview &&
        other.popularity == popularity &&
        other.posterPath == posterPath &&
        listEquals(other.productionCompanies, productionCompanies) &&
        listEquals(other.productionCountries, productionCountries) &&
        other.releaseDate == releaseDate &&
        other.revenue == revenue &&
        other.runtime == runtime &&
        listEquals(other.spokenLanguages, spokenLanguages) &&
        other.status == status &&
        other.tagline == tagline &&
        other.title == title &&
        other.video == video &&
        other.voteAverage == voteAverage &&
        other.voteCount == voteCount;
  }

  @override
  int get hashCode {
    return adult.hashCode ^
        backdropPath.hashCode ^
        bellogsToCollection.hashCode ^
        budget.hashCode ^
        genres.hashCode ^
        homepage.hashCode ^
        id.hashCode ^
        imdbId.hashCode ^
        originalLanguage.hashCode ^
        originalTitle.hashCode ^
        overview.hashCode ^
        popularity.hashCode ^
        posterPath.hashCode ^
        productionCompanies.hashCode ^
        productionCountries.hashCode ^
        releaseDate.hashCode ^
        revenue.hashCode ^
        runtime.hashCode ^
        spokenLanguages.hashCode ^
        status.hashCode ^
        tagline.hashCode ^
        title.hashCode ^
        video.hashCode ^
        voteAverage.hashCode ^
        voteCount.hashCode;
  }
}
