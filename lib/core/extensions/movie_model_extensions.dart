import 'package:intl/intl.dart';

import '../constants/api_constants.dart';
import '../models/movie_model.dart';

extension MovieModelExtensions on MovieModel {
  // Getter for full poster path
  String get fullPosterPath {
    if (posterPath != null) {
      // ApiConstants'dan base URL ve boyutu al
      return ApiConstants.imageBaseUrl +
          ApiConstants.defaultPosterSize +
          posterPath!;
    }
    // Poster path yoksa boş string veya varsayılan bir placeholder URL döndür
    return ""; // Veya örneğin: 'assets/images/placeholder.png'
  }

  // Getter for full backdrop path (isteğe bağlı, farklı boyutla)
  String get fullBackdropPath {
    if (backdropPath != null) {
      return "${ApiConstants.imageBaseUrl}w780${backdropPath!}";
    }
    return "";
  }

  // Boyut parametresi alan versiyon (daha esnek)
  String getFullPosterPath({String size = ApiConstants.defaultPosterSize}) {
    if (posterPath != null) {
      return ApiConstants.imageBaseUrl + size + posterPath!;
    }
    return "";
  }

  // Formatted Release Date Getter
  String get formattedReleaseDate {
    if (releaseDate == null || releaseDate!.isEmpty) {
      return "-"; // Veya "Tarih Yok"
    }
    try {
      // Tarihi YYYY-MM-DD formatında parse et
      final DateTime parsedDate = DateTime.parse(releaseDate!);
      // DD.MM.YYYY formatına çevir
      final DateFormat formatter = DateFormat('dd.MM.yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      // Parse etme başarısız olursa orijinal tarihi veya hata mesajını döndür
      print("Date formatting error for '$releaseDate': $e");
      return releaseDate!; // Veya "Geçersiz Tarih"
    }
  }
}
