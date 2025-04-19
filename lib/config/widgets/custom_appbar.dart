import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';

import '../items/colors/app_colors.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.onPressed,
    this.centerTitle,
    this.color,
    this.titleColor,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final dynamic onPressed;
  final bool? centerTitle;
  final Color? color;
  final Color? titleColor;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.color ?? Colors.white,
      toolbarHeight: context.dynamicHeight(0.1),
      centerTitle: widget.centerTitle ?? true,
      elevation: 0,
      surfaceTintColor: widget.color ?? Colors.white,
      title: Text(
        widget.title ?? "",
        style: TextStyle(
          color: widget.titleColor ?? AppColors.primaryColor,
          fontSize: context.dynamicHeight(0.02),
        ),
      ),
      automaticallyImplyLeading: false,
      leading: widget.leading ?? const SizedBox(),
      /* IconButton(
            onPressed: () {
              if (widget.onPressed != null) {
                widget.onPressed();
              }
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryColor,
              size: context.dynamicHeight(0.02),
            ),
          ), */
      actions: widget.actions,
    );
  }
}
