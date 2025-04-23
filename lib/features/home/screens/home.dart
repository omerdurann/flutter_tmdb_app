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

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(homeProvider);

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
            child: movieState.when(
              data: (movies) {
                if (movies.isEmpty) {
                  return const Center(
                    child: Text(
                      'Gösterilecek film bulunamadı.',
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  );
                }
                return MovieGridView(movies: movies);
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  'Filmler yüklenirken hata oluştu: ${error.toString()}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
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
