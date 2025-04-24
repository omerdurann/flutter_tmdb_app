// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../constants/api_constants.dart';
import '../models/movie_model.dart';

extension MovieModelExtensions on MovieModel {
  // Getter for full poster path
  String get fullPosterPath {
    if (posterPath != null) {
      return ApiConstants.imageBaseUrl +
          ApiConstants.defaultPosterSize +
          posterPath!;
    }
    return "";
  }

  // Getter for full backdrop path
  String get fullBackdropPath {
    if (backdropPath != null) {
      return "${ApiConstants.imageBaseUrl}w780${backdropPath!}";
    }
    return "";
  }

  // Boyut parametresi alan versiyon
  String getFullPosterPath({String size = ApiConstants.defaultPosterSize}) {
    if (posterPath != null) {
      return ApiConstants.imageBaseUrl + size + posterPath!;
    }
    return "";
  }

  // Formatted Release Date Getter
  String get formattedReleaseDate {
    if (releaseDate == null || releaseDate!.isEmpty) {
      return "-";
    }
    try {
      final DateTime parsedDate = DateTime.parse(releaseDate!);
      final DateFormat formatter = DateFormat('dd.MM.yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return releaseDate!;
    }
  }
}
