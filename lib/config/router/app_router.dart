// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/features/details/screens/details.dart';
import 'package:flutter_tmdb_app/features/favorite/screens/favorites.dart';
import '../../features/home/screens/home.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return _fadeRoute(
          settings: settings,
          view: const Home(),
        );

      case RouteNames.favorites:
        return _slideRoute(
          settings: settings,
          view: const Favorites(),
        );

      case RouteNames.movieDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final movieId = args?['movieId'] as int?;
        return _scaleRoute(
          settings: settings,
          view: DetailsScreen(
            movieId: movieId,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }

  static Route<dynamic> _slideRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (animation, __, child) => view,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: end,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> _fadeRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (animation, __, child) => view,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static Route<dynamic> _scaleRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (animation, __, child) => view,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> _rotateRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (animation, __, child) => view,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
    );
  }

  static Route<dynamic> _sizeRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (animation, __, child) => view,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Align(
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
    );
  }

  //sayfanın alttan yukarıya doğru açılması
  static Route<dynamic> _bottomToTopRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (animation, __, child) => view,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
