import 'dart:async'; 

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';
import 'package:flutter_tmdb_app/features/home/providers/home_provider.dart';
import 'package:flutter_tmdb_app/features/home/screens/home.dart'
    show isSearchingProvider, searchBarHasTextProvider;

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  late final TextEditingController _searchController;
  Timer? _debounce;
  final _debounceDuration = const Duration(milliseconds: 500); 

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); 
    super.dispose();
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isNotEmpty && !ref.read(isSearchingProvider)) {
      ref.read(isSearchingProvider.notifier).state = true;
    } else if (trimmedQuery.isEmpty && ref.read(isSearchingProvider)) {
      ref.read(isSearchingProvider.notifier).state = false;
    }
    ref.read(searchMoviesProvider.notifier).searchMovies(trimmedQuery);
  }

  void _clearSearch() {
    _debounce?.cancel(); 
    _searchController.clear();
    ref.read(searchMoviesProvider.notifier).clearSearch();
    if (ref.read(isSearchingProvider)) {
      ref.read(isSearchingProvider.notifier).state = false;
    }
    ref.read(searchBarHasTextProvider.notifier).state = false;
    FocusScope.of(context).unfocus();
  }

  void _onSearchChanged(String query) {
    ref.read(searchBarHasTextProvider.notifier).state = query.isNotEmpty;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(_debounceDuration, () {
      final currentText = _searchController.text.trim();
      if (currentText.length >= 2) {
        _performSearch(currentText);
      } else if (currentText.isEmpty) {
        if (ref.read(isSearchingProvider)) {
          ref.read(searchMoviesProvider.notifier).clearSearch();
          ref.read(isSearchingProvider.notifier).state = false;
        }
      } else {
        if (ref.read(isSearchingProvider)) {
          ref.read(searchMoviesProvider.notifier).clearSearch();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showClearButton = ref.watch(searchBarHasTextProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.04),
        vertical: context.dynamicHeight(0.015),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Film ara...',
          hintStyle: TextStyle(
              color: AppColors.darkGrayColor,
              fontSize: context.dynamicHeight(0.018)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
                left: context.dynamicWidth(0.04),
                right: context.dynamicWidth(0.02)),
            child: Icon(
              Icons.search,
              color: AppColors.darkGrayColor,
              size: context.dynamicHeight(0.025),
            ),
          ),
          suffixIcon: showClearButton
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.darkGrayColor,
                    size: context.dynamicHeight(0.025),
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            minHeight: context.dynamicHeight(0.025),
            minWidth: context.dynamicWidth(0.1),
          ),
          filled: true,
          fillColor: AppColors.grayColor,
          contentPadding: EdgeInsets.symmetric(
            vertical: context.dynamicHeight(0.018),
            horizontal: context.dynamicWidth(0.04),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.dynamicWidth(0.08)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.dynamicWidth(0.08)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.dynamicWidth(0.08)),
            borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: context.dynamicWidth(0.004)),
          ),
        ),
        style: TextStyle(
            color: AppColors.blackColor,
            fontSize: context.dynamicHeight(0.018)),
        cursorColor: AppColors.primaryColor,
        textInputAction: TextInputAction.search,
        onChanged: _onSearchChanged, 
      ),
    );
  }
}
