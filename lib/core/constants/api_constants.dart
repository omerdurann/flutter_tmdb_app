import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiConstantNotifier = ChangeNotifierProvider<ApiConstants>((ref) {
  return ApiConstants();
});

class ApiConstants extends ChangeNotifier {
  ApiConstants();
  static const String baseUrl = "https://api.themoviedb.org/3";
  // Resim için sabitler
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/";
  static const String defaultPosterSize = "w500";
}
