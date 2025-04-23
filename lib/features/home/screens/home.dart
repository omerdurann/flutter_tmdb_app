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

// Arama durumunu takip etmek için provider
final isSearchingProvider = StateProvider<bool>((ref) => false);

// Arama çubuğunun metin içerip içermediğini takip eden provider (Temizle butonu için)
final searchBarHasTextProvider = StateProvider<bool>((ref) => false);

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  // Sayfalama için ScrollController
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
    // Kullanıcı listenin sonuna yaklaştığında ve daha fazla veri varsa yükle
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_scrollController.position.outOfRange) {
      final isSearching = ref.read(isSearchingProvider);
      if (isSearching) {
        // Arama sonuçları için daha fazla veri yükle
        // Not: Provider'ın kendi içindeki _isLoadingMore kontrolü tekrar tekrar çağırmayı engeller
        ref.read(searchMoviesProvider.notifier).loadMoreResults();
      } else {
        // Trend filmler için daha fazla veri yükle
        ref.read(trendingMoviesProvider.notifier).loadMoreData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Arama durumunu ve ilgili provider'ı izle
    final isSearching = ref.watch(isSearchingProvider);
    final movieState =
        ref.watch(isSearching ? searchMoviesProvider : trendingMoviesProvider);

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
              label: const Text('3'),
              isLabelVisible: true,
              offset: const Offset(-4, 4),
              child: IconButton(
                icon: SvgPicture.asset(
                  ImageConstants.favorites.toSvg,
                  color: AppColors.whiteColor,
                  height: context.dynamicHeight(0.028),
                ),
                onPressed: () {
                  print("Favoriler ikonuna tıklandı!");
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
            // Sayfalama için NotificationListener yerine ScrollController kullanıldı
            child: movieState.when(
              data: (movies) {
                if (movies.isEmpty) {
                  // Arama aktifse ve sonuç yoksa farklı bir mesaj gösterilebilir
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
                // MovieGridView'e ScrollController'ı ver
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
              // İlk yükleme veya arama yüklemesi için gösterilir
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
