import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/utility/enums/image_constants.dart';
import 'package:flutter_tmdb_app/features/favorite/screens/favorites.dart';
import 'package:flutter_tmdb_app/features/home/providers/home_provider.dart';
import '../../../config/items/colors/app_colors.dart';
import '../../../config/widgets/custom_appbar.dart';
import '../../../config/widgets/movie_grid_view.dart';
import '../widgets/search_bar_widget.dart';
import 'package:flutter_tmdb_app/features/favorite/providers/favorites_provider.dart';
import '../../../config/widgets/custom_loading_anim.dart';

final isSearchingProvider = StateProvider<bool>((ref) => false);

final searchBarHasTextProvider = StateProvider<bool>((ref) => false);

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_scrollController.position.outOfRange) {
      final isSearching = ref.read(isSearchingProvider);
      if (isSearching) {
        ref.read(searchMoviesProvider.notifier).loadMoreResults();
      } else {
        ref.read(trendingMoviesProvider.notifier).loadMoreData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final movieState =
        ref.watch(isSearching ? searchMoviesProvider : trendingMoviesProvider);
    final favoritesState = ref.watch(favoritesProvider);

    final favoriteCount = favoritesState.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0, 
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.dynamicHeight(0.07),
        ),
        child: CustomAppBar(
          color: AppColors.darkBackgroundColor,
          titleColor: AppColors.whiteColor,
          title: "Ana Sayfa",
          actions: [
            Badge(
              label: Text(favoriteCount.toString()),
              isLabelVisible: favoriteCount > 0,
              offset: const Offset(-4, 4),
              child: IconButton(
                icon: SvgPicture.asset(
                  ImageConstants.favorites.toSvg,
                  color: AppColors.whiteColor,
                  height: context.dynamicHeight(0.028),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Favorites()),
                  );
                },
                tooltip: 'Favoriler',
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.darkBackgroundColor,
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: movieState.when(
              data: (movies) {
                if (movies.isEmpty) {
                  final message = isSearching
                      ? 'Arama sonucu bulunamadı.'
                      : 'Gösterilecek film bulunamadı.';
                  return Center(
                    child: Text(
                      message,
                      style: const TextStyle(color: AppColors.whiteColor),
                    ),
                  );
                }
                return MovieGridView(
                    movies: movies, scrollController: _scrollController);
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  'Filmler yüklenirken hata oluştu: ${error.toString()}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              loading: () => Center(
                child: LoadingAnimationWidget(
                  width: context.dynamicWidth(0.2),
                  height: context.dynamicWidth(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
