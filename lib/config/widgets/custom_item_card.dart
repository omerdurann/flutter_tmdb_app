// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';

import '../items/colors/app_colors.dart';

class CustomInfoCard extends StatelessWidget {
  const CustomInfoCard({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.identifier = '',
    this.additionalInfo = '',
    this.titleLabel = '',
    this.subtitleLabel = '',
    this.identifierLabel = '',
    this.additionalLabel = '',
    this.child = false,
    this.childWidget,
    this.suffixIcon,
    this.prefixIcon,
    this.thirdIcon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String identifier;
  final String additionalInfo;
  final String titleLabel;
  final String subtitleLabel;
  final String identifierLabel;
  final String additionalLabel;
  final bool child;
  final Widget? childWidget;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final Icon? thirdIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: context.paddingVerticalLow,
        child: Card(
          surfaceTintColor: AppColors.whiteColor,
          color: AppColors.whiteColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.dynamicWidth(0.04),
              vertical: context.dynamicHeight(0.01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.hintColor,
                      fontSize: context.dynamicWidth(0.03),
                    ),
                  ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: context.dynamicWidth(0.03),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (titleLabel.isNotEmpty || identifierLabel.isNotEmpty)
                  const Divider(
                    color: AppColors.grayColor,
                    thickness: 1,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (titleLabel.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleLabel,
                            style: TextStyle(
                              color: AppColors.hintColor,
                              fontSize: context.dynamicWidth(0.03),
                            ),
                          ),
                          if (subtitleLabel.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: context.paddingRightLow,
                                  child: prefixIcon ??
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color: AppColors.hintColor,
                                        size: context.dynamicWidth(0.05),
                                      ),
                                ),
                                Text(
                                  subtitleLabel,
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: context.dynamicWidth(0.03),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    if (identifierLabel.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            identifierLabel,
                            style: TextStyle(
                              color: AppColors.hintColor,
                              fontSize: context.dynamicWidth(0.03),
                            ),
                          ),
                          if (identifier.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: context.paddingRightLow,
                                  child: suffixIcon ??
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color: AppColors.hintColor,
                                        size: context.dynamicWidth(0.05),
                                      ),
                                ),
                                Text(
                                  identifier,
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: context.dynamicWidth(0.03),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
                if (additionalLabel.isNotEmpty || additionalInfo.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: AppColors.dividerColor,
                        thickness: 1,
                      ),
                      if (additionalLabel.isNotEmpty)
                        Text(
                          additionalLabel,
                          style: TextStyle(
                            color: AppColors.hintColor,
                            fontSize: context.dynamicWidth(0.03),
                          ),
                        ),
                      if (additionalInfo.isNotEmpty)
                        Row(
                          children: [
                            Padding(
                              padding: context.paddingRightLow,
                              child: thirdIcon ??
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColors.hintColor,
                                    size: context.dynamicWidth(0.05),
                                  ),
                            ),
                            Text(
                              additionalInfo,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: context.dynamicWidth(0.03),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                if (child) childWidget ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
