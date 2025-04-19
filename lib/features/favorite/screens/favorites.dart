import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/config/widgets/custom_appbar.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';

class Favorites extends ConsumerWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          context.dynamicHeight(0.07),
        ),
        child: const CustomAppBar(
          color: AppColors.darkBackgroundColor,
          titleColor: AppColors.whiteColor,
          title: "Favoriler",
        ),
      ),
      backgroundColor: AppColors.darkBackgroundColor,
      body: const Center(
        child: Text(
          'Favoriler Ekranı',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
