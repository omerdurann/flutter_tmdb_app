import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';

import 'package:toastification/toastification.dart';

import '../../items/colors/app_colors.dart';
import '../../models/notification_model.dart';

class Utils {
  const Utils._();

  static void showFlushbar(
      BuildContext context, FlushbarNotificationModel notificationModel) {
    toastification.show(
      context: context,
      type: notificationModel.type,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(
        notificationModel.title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.whiteColor,
              fontSize: context.dynamicWidth(0.04),
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.justify,
      ),
      description: Text(
        notificationModel.subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: context.dynamicWidth(0.032),
              color: AppColors.whiteColor,
            ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
      ),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(
        context.dynamicWidth(0.05),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }
}
