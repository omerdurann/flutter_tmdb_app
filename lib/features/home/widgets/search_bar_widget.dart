import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';
import 'package:flutter_tmdb_app/config/items/colors/app_colors.dart';

class SearchBarWidget extends ConsumerWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.04),
        vertical: context.dynamicHeight(0.015),
      ),
      child: TextField(
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
        // Add controller and onChanged logic later as needed
      ),
    );
  }
}
