import '../../../core/constants/api_constants.dart';

enum ApiEndPoints {
  trendingMoviesDay('trending/movie/day'),
  searchMovies('search/movie'),
  movieDetail('movie'),
  ;

  const ApiEndPoints(this.endPoint);
  String get getEndpoint => '${ApiConstants.baseUrl}/$endPoint';

  final String endPoint;
}
